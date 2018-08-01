//
//  CaptureMode.swift
//  kPlayground
//
//  Created by s.kananat on 2018/08/01.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

enum CaptureMode: String {
    case none = "None", photo = "Photo", video = "Video"
    
    func toggle() -> CaptureMode {
        switch self {
        case .none:
            return .none
        
        case .photo:
            return .video
        
        case .video:
            return .photo
        }
    }
}
