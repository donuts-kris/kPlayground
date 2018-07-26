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

    let mode = MutableProperty<CaptureMode>(.photo)
    let source = MutableProperty<CaptureSource>(.back)
    
    let (photoSignal, photoObserver) = Signal<UIImage?, NoError>.pipe()
    
    lazy var closeButtonPressed: Action<Void, Void, NoError> = {
        return Action { value in
            return SignalProducer(value: value)
        }
    }()
    
    lazy var captureButtonPressed: Action<Void, Void, NoError> = {
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

extension CameraViewModel {
    
    enum CaptureMode: String {
        case photo = "Photo", video = "Video"
        
        mutating func toggle() {
            self = (self == .photo) ? .video : .photo
        }
    }
    
    enum CaptureSource: String {
        case front = "Front", back = "Back"
        
        mutating func toggle() {
            self = (self == .front) ? .back : .front
        }
    }
}
