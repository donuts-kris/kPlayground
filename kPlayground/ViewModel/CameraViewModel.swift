//
//  CameraViewModel.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/25.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import Result
import ReactiveCocoa
import ReactiveSwift

class CameraViewModel {

    lazy var closeButtonPressed: Action<Void, Void, NoError> = {
        return Action { value in
            return SignalProducer(value: value)
        }
    }()
    
    lazy var captureButtonPressed: Action<UIImage, UIImage, NoError> = {
        return Action { value in
            return SignalProducer(value: value)
        }
    }()
}
