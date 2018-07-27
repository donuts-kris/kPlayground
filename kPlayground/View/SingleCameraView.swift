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

    private var _name = "Unknown"
    
    var name: String {
        get {
            return self._name
        }
    }
    
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
    
    convenience init?(_ device: AVCaptureDevice, _ name: String?) {
        self.init()
        
        if let name = name {
            self._name = name
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
        
            guard self.session.canAddInput(input) else { return nil }
            self.session.addInput(input)
            
            guard self.session.canAddOutput(photoOutput) else { return nil }
            self.session.addOutput(photoOutput)
        }
        catch {
            return nil
        }
        
        self.layer.insertSublayer(self.previewLayer, at: 0)
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
