//
//  CameraView.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/24.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation
import Result
import ReactiveSwift

class CameraView: View {
    
    private var captureSession = AVCaptureSession()
    
    private var currentCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var backCamera: AVCaptureDevice?
    
    private var photoOutput = AVCapturePhotoOutput()
    
    private lazy var cameraPreviewLayer: AVCaptureVideoPreviewLayer = {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        cameraPreviewLayer.frame = self.frame
        return cameraPreviewLayer
    }()
    
    func bind(_ viewModel: CameraViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        
        disposable += viewModel.captureButtonPressed.values.observe(on: UIScheduler()).observeValues { [weak self] in
            self?.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: viewModel)
        }
        
        disposable += viewModel.source.producer.observe(on: UIScheduler()).startWithValues { [weak self] value in
            if value == .back {
                return
            }
            
            self?.currentCamera = self?.frontCamera
            self?.setupInputOutput()
        }
        
        return disposable
    }
    
    private func setupCaptureSession() {
        self.captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        devices.forEach { device in
            if device.position == .back {
                self.backCamera = device
            }
            else if device.position == .front {
                self.frontCamera = device
            }
            
            self.currentCamera = self.backCamera
        }
    }
    
    private func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            self.captureSession.addInput(captureDeviceInput)
            self.photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            self.captureSession.addOutput(self.photoOutput)
        }
        catch {
            print(error)
        }
    }
}

extension CameraView {
    override func didLoad() {
        self.setupDevice()
        self.setupCaptureSession()
        self.setupInputOutput()
        
        self.layer.insertSublayer(self.cameraPreviewLayer, at: 0)
    }
    
    override func willAppear() {
        self.captureSession.startRunning()
        self.cameraPreviewLayer.connection?.isEnabled = true
    }
    
    override func didDisappear() {
        self.captureSession.stopRunning()
        self.cameraPreviewLayer.connection?.isEnabled = false
    }
}
