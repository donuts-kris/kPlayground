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
    
    let mode = MutableProperty<CaptureMode>(.photo)
    let source = MutableProperty<String>("Unknown")
    
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

extension CameraViewModel {
    
    enum CaptureMode: String {
        case photo = "Photo", video = "Video"
        
        mutating func toggle() {
            self = (self == .photo) ? .video : .photo
        }
    }
}
