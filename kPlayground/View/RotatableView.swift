//
//  RotatableView.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/24.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

class RotatableView: UIView {

    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private final func orientationDidChange() {
        
        guard self.superview != nil else { return }
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientationDidChangePortrait()
            
        case .portraitUpsideDown:
            orientationDidChangePortraitUpsideDown()
            
        case .landscapeLeft:
            orientationDidChangeLandscapeLeft()
            
        case .landscapeRight:
            orientationDidChangeLandscapeRight()
            
        default:
            break
        }
    }
    
    @objc dynamic internal func orientationDidChangePortrait() { }
    @objc dynamic internal func orientationDidChangePortraitUpsideDown() { }
    @objc dynamic internal func orientationDidChangeLandscapeLeft() { }
    @objc dynamic internal func orientationDidChangeLandscapeRight() { }
}
