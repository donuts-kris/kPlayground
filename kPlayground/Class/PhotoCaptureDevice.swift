//
//  PhotoCaptureDevice.swift
//  kPlayground
//
//  Created by s.kananat on 2018/08/01.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoCaptureDevice {
    
    lazy var inputs: [AVCaptureInput] = {
        return []
    }()
    
    lazy var output: AVCapturePhotoOutput = {
        let output = AVCapturePhotoOutput()
        output.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        return output
    }()
    
    init() {
        _ = inputs
        _ = output
    }
    
    func capture(delegate: AVCapturePhotoCaptureDelegate) {
        if let connection = self.output.connection(with: .video), connection.isVideoOrientationSupported {
            connection.videoOrientation = UIDevice.current.videoOrientation
        }
        
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: delegate)
    }
}
