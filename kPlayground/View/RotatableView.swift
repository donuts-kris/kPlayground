//
//  RotatableView.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/24.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

internal class RotatableView: View {

    @objc internal final func orientationDidChange() {
        
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

extension RotatableView {
    override func didAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
        
        self.orientationDidChange()
    }
    
    override func didDisappear() {
        NotificationCenter.default.removeObserver(self)
    }
}
