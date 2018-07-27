//
//  CGRectExtension.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/27.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

extension CGRect {
    static var screen: CGRect {
        return UIScreen.main.bounds
    }
    
    static var screenIgnoreOrientation: CGRect {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            return screen.transpose
        }
        
        return screen
    }
    
    var transpose: CGRect {
        return CGRect(x: self.minX, y: self.minY, width: self.height, height: self.width)
    }
}
