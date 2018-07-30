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

class SingleCameraView: RotatableView {

    private(set) public var name = "Unknown"
    
    private lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        return session
    }()
    
    private lazy var photoOutput: AVCapturePhotoOutput = {
        let photoOutput = AVCapturePhotoOutput()
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        return photoOutput
    }()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = self.frame
        return previewLayer
    }()
    
    convenience init?(_ device: AVCaptureDevice, _ name: String) {
        self.init()
        
        self.name = name

        do {
            let input = try AVCaptureDeviceInput(device: device)
        
            guard self.session.canAddInput(input) else { return nil }
            self.session.addInput(input)
            
            guard self.session.canAddOutput(self.photoOutput) else { return nil }
            self.session.addOutput(self.photoOutput)
        }
        catch {
            return nil
        }
        
        self.layer.insertSublayer(self.previewLayer, at: 0)
        _ = self.connect()
        self.disconnect()
    }
    
    func connect() -> AVCapturePhotoOutput {
        self.session.startRunning()
        self.previewLayer.connection?.isEnabled = true
        
        self.isHidden = false

        return self.photoOutput
    }
    
    func disconnect() {
        self.session.stopRunning()
        self.previewLayer.connection?.isEnabled = false
        
        self.isHidden = true
    }
}

extension SingleCameraView {
    override func orientationDidChangePortrait() {
        self.photoOutput.connection(with: .video)?.videoOrientation = .portrait
    }
    
    override func orientationDidChangePortraitUpsideDown() {
        self.photoOutput.connection(with: .video)?.videoOrientation = .portraitUpsideDown
    }
    
    override func orientationDidChangeLandscapeLeft() {
        self.photoOutput.connection(with: .video)?.videoOrientation = .landscapeLeft
    }
    
    override func orientationDidChangeLandscapeRight() {
        self.photoOutput.connection(with: .video)?.videoOrientation = .landscapeRight
    }
}
