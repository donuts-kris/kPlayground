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
    
    private var currentCamera : AVCaptureDevice?
    private var rearCamera : AVCaptureDevice?
    private var frontCamera : AVCaptureDevice?
    
    private var photoOutput = AVCapturePhotoOutput()
    
    private lazy var cameraPreviewLayer : AVCaptureVideoPreviewLayer = {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        cameraPreviewLayer.frame = self.frame
        //cameraPreviewLayer.
        return cameraPreviewLayer
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

        self.backgroundColor = .red
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.buttonClicked), name: .UIDeviceOrientationDidChange, object: nil)
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    @objc private func buttonClicked() {
        print("wtf2")
    }
    
    private func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    private func setupDevice(){
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
    
    private func setupInputOutput(){
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
    
    private func setupPreviewLayer(){
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
}
