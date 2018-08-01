//
//  PositionExtension.swift
//  kPlayground
//
//  Created by s.kananat on 2018/08/01.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation

extension AVCaptureDevice.Position {
    var stringValue: String {
        switch self {
        case .back:
            return "Back"
        case .front:
            return "Front"
        case .unspecified:
            return "Unknown"
        }
    }
}
