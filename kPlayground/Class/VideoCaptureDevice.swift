//
//  VideoCaptureDevice.swift
//  kPlayground
//
//  Created by s.kananat on 2018/08/01.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCaptureDevice {

    lazy var inputs: [AVCaptureDeviceInput] = {
        return []
    }()
    
    lazy var output: AVCaptureMovieFileOutput = {
        let output = AVCaptureMovieFileOutput()
        if let connection = output.connection(with: .video), connection.isVideoStabilizationSupported {
            connection.preferredVideoStabilizationMode = .auto
        }
        return output
    }()
    
    private lazy var tempURL: URL! = {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }()
    
    init() {
        _ = inputs
        _ = output
    }
    
    func capture(delegate: AVCaptureFileOutputRecordingDelegate) {
        guard !self.output.isRecording else { return }
        
        if let connection = self.output.connection(with: .video), connection.isVideoOrientationSupported {
            connection.videoOrientation = UIDevice.current.videoOrientation
        }

        self.output.startRecording(to: self.tempURL, recordingDelegate: delegate)
    }
    
    func endCapture() {
        guard self.output.isRecording else { return }
        
        self.output.stopRecording()
    }
}
