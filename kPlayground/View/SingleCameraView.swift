//
//  SingleCameraView.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/27.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation
import ReactiveSwift

class SingleCameraView: View {
    private(set) var name = "Other"
    
    private lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        return session
    }()
    
    private var cameraInput: AVCaptureDeviceInput!
    private var microphoneInput: AVCaptureDeviceInput!
    
    private lazy var photoOutput: AVCapturePhotoOutput = {
        let output = AVCapturePhotoOutput()
        output.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        return output
    }()
    
    private lazy var videoOutput: AVCaptureMovieFileOutput = {
        let output = AVCaptureMovieFileOutput()
        if let connection = output.connection(with: .video), connection.isVideoStabilizationSupported {
            connection.preferredVideoStabilizationMode = .auto
        }
        return output
    }()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = self.frame
        return previewLayer
    }()
    
    private static var orientation: AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    init?(_ device: AVCaptureDevice, _ name: String) {
        self.name = name
        
        super.init()
        
        if device.isSmoothAutoFocusSupported {
            do {
                try device.lockForConfiguration()
                device.isSmoothAutoFocusEnabled = false
                device.unlockForConfiguration()
            }
            catch {
            }
        }
        
        do {
            self.cameraInput = try AVCaptureDeviceInput(device: device)
        }
        catch {
            return nil
        }
        
        if self.session.canAddInput(cameraInput) {
            self.session.addInput(cameraInput)
        }

        let microphone = AVCaptureDevice.default(for: .audio)
        
        do {
            microphoneInput = try AVCaptureDeviceInput(device: microphone!)
        }
        catch {
            return nil
        }
        
        self.layer.insertSublayer(self.previewLayer, at: 0)
        
        self.setActive(true)
        self.setActive(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: CameraViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        
        disposable += viewModel.mode.producer.observe(on: UIScheduler()).startWithValues { [weak self] value in
            guard let sSelf = self else { return }
            
            switch value {
            case .photo:
                sSelf.changeModeToPhoto()
                
            case .video:
                sSelf.changeModeToVideo()
            }
        }
        
        return disposable
    }
    
    func setActive(_ active: Bool) {
        if active {
            DispatchQueue.main.async {
                self.session.startRunning()
            }
        }
        else {
            DispatchQueue.main.async {
                self.session.stopRunning()
            }
        }
        
        self.previewLayer.connection?.isEnabled = active
        
        self.isHidden = !active
    }
    
    func capturePhoto(delegate: AVCapturePhotoCaptureDelegate) {
        if let connection = videoOutput.connection(with: .video), connection.isVideoOrientationSupported {
            connection.videoOrientation = SingleCameraView.orientation
        }
        
        self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: delegate)
    }
    
    func startRecording(delegate: AVCaptureFileOutputRecordingDelegate) {
        guard !videoOutput.isRecording else { return }
        
        if let connection = videoOutput.connection(with: .video), connection.isVideoOrientationSupported {
            connection.videoOrientation = SingleCameraView.orientation
        }
        
        if let outputURL = self.tempURL() {
            self.videoOutput.startRecording(to: outputURL, recordingDelegate: delegate)
        }
    }
    
    func stopRecording() {
        guard videoOutput.isRecording else { return }
        
        videoOutput.stopRecording()
    }
    
    private func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    
    private func changeModeToPhoto() {
        self.session.removeInput(self.microphoneInput)
        self.session.removeOutput(self.videoOutput)
        
        if session.canAddOutput(self.photoOutput) {
            session.addOutput(self.photoOutput)
        }
    }
    
    private func changeModeToVideo() {
        self.session.removeOutput(self.photoOutput)
        
        if self.session.canAddInput(self.microphoneInput) {
            session.addInput(self.microphoneInput)
        }
        
        if session.canAddOutput(self.videoOutput) {
            session.addOutput(self.videoOutput)
        }
    }
}
