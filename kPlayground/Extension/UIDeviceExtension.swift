//
//  UIDevice.swift
//  kPlayground
//
//  Created by s.kananat on 2018/08/01.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation

extension UIDevice {
    var videoOrientation: AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
}
