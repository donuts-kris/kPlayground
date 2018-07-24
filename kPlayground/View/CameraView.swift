//
//  CameraView.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/24.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {

    private var captureSession = AVCaptureSession()
    
    private var currentCamera: AVCaptureDevice?
    private var rearCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    
    private var photoOutput = AVCapturePhotoOutput()
    
    private lazy var cameraPreviewLayer: AVCaptureVideoPreviewLayer = {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        cameraPreviewLayer.frame = self.frame
        return cameraPreviewLayer
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    private func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        devices.forEach { device in
            if device.position == .back {
                rearCamera = device
            }
            else if device.position == .front {
                frontCamera = device
            }
            
            currentCamera = rearCamera
        }
    }
    
    private func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput)
        }
        catch {
            print(error)
        }
    }
    
    private func setupPreviewLayer() {
        self.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    private func startRunningCaptureSession(){
        captureSession.startRunning()
    }
}

extension CameraView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cameraPreviewLayer.frame.size = self.frame.size
    }
    
    override func updateConstraints() {
        self.snp.remakeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
