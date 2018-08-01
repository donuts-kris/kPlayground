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
    private(set) var position: AVCaptureDevice.Position
    
    private lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        return session
    }()
    
    private var cameraInput: AVCaptureDeviceInput!
    
    private lazy var microphoneInput: AVCaptureDeviceInput! = {
        let microphone = AVCaptureDevice.default(for: .audio)
        do {
            return try AVCaptureDeviceInput(device: microphone!)
        }
        catch {
            return nil
        }
    }()
    
    lazy var photo: PhotoCaptureDevice = {
        let device = PhotoCaptureDevice()
        device.inputs.append(self.cameraInput)
        return device
    }()
    
    lazy var video: VideoCaptureDevice = {
        let device = VideoCaptureDevice()
        device.inputs.append(self.cameraInput)
        device.inputs.append(self.microphoneInput)
        return device
    }()

    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.videoGravity = .resizeAspectFill
        layer.connection?.videoOrientation = .portrait
        layer.frame = self.frame
        return layer
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
    
    init(_ device: AVCaptureDevice) {
        self.position = device.position
        
        super.init()
        
        do {
            if device.isSmoothAutoFocusSupported {
                try device.lockForConfiguration()
                device.isSmoothAutoFocusEnabled = false
                device.unlockForConfiguration()
            }
            
            self.cameraInput = try AVCaptureDeviceInput(device: device)
        }
        catch {
            print("\(error.localizedDescription)")
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
            self?.changeMode(to: value)
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
    
    private func changeMode(to mode: CaptureMode) {
        var inputs: [AVCaptureInput]
        var output: AVCaptureOutput
        
        switch mode {
        case .photo:
            inputs = photo.inputs
            output = photo.output
            
        case .video:
            inputs = video.inputs
            output = video.output
            
        case .none:
            return
        }
        
        for input in self.session.inputs {
            self.session.removeInput(input)
        }
        
        for output in self.session.outputs {
            self.session.removeOutput(output)
        }
        
        for input in inputs {
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
        }

        if self.session.canAddOutput(output) {
            self.session.addOutput(output)
        }
    }
}
