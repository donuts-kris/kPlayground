//
//  CameraViewModel.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/25.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import AVFoundation
import Result
import ReactiveCocoa
import ReactiveSwift

class CameraViewModel: NSObject {
    let (photoSignal, photoObserver) = Signal<UIImage?, NoError>.pipe()
    let (videoSignal, videoObserver) = Signal<URL?, NoError>.pipe()
    
    var supportedModes: [CaptureMode]
    var supportedCameras: [AVCaptureDevice.Position]
    
    var mode: MutableProperty<CaptureMode>
    var position: MutableProperty<AVCaptureDevice.Position>
    
    let recording = MutableProperty<Bool>(false)

    lazy var captureButtonPressed: Action<Void, Void, NoError> = {
        return Action { value in
            return SignalProducer(value: value)
        }
    }()
    
    lazy var switchButtonPressed: Action<Void, Void, NoError> = {
        return Action { value in
            return SignalProducer(value: value)
        }
    }()
    
    lazy var closeButtonPressed: Action<Void, Void, NoError> = {
        return Action { value in
            return SignalProducer(value: value)
        }
    }()
    
    init(_ supportedModes: [CaptureMode], _ supportedCameras: [AVCaptureDevice.Position]) {
        
        self.supportedModes = supportedModes
        self.supportedCameras = supportedCameras
        
        self.mode = MutableProperty<CaptureMode>(supportedModes.count > 0 ? supportedModes[0] : .none)
        
        if supportedCameras.count == 0 {
            self.supportedCameras.append(.back)
        }
        
        self.position = MutableProperty<AVCaptureDevice.Position>(self.supportedCameras[0])
        
        super.init()
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            self.photoObserver.send(value: nil)
            return
        }
        
        self.photoObserver.send(value: image)
    }
}

extension CameraViewModel: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("fileOutput")
        
        guard error != nil else {
            self.videoObserver.send(value: nil)
            return
        }
        
        self.videoObserver.send(value: outputFileURL)
    }
}
