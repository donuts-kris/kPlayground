//
//  AutoRotateView.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/25.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

internal class AutoRotateView: RotatableView {
    
    internal var referenceView: UIView? {
        return superview
    }
    
    internal var animatingDuration: TimeInterval {
        return 0.4
    }
    
    private func makeConstraintsPortrait() {
        self.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            if let referenceView = self.referenceView {
                make.width.equalTo(referenceView.snp.width)
                make.height.equalTo(referenceView.snp.height)
            }
        }
    }
    
    private func makeContraintsLandscape() {
        self.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            if let referenceView = self.referenceView {
                make.width.equalTo(referenceView.snp.height)
                make.height.equalTo(referenceView.snp.width)
            }
        }
    }
}

extension AutoRotateView {
    internal override func orientationDidChangePortrait() {
        UIView.animate(withDuration: animatingDuration) {
            self.transform = CGAffineTransform.identity
            
            self.makeConstraintsPortrait()
        }
    }
    
    internal override func orientationDidChangePortraitUpsideDown() {
        UIView.animate(withDuration: animatingDuration) {
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            
            self.makeConstraintsPortrait()
        }
    }
    
    internal override func orientationDidChangeLandscapeLeft() {
        UIView.animate(withDuration: animatingDuration) {
            self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
            
            self.makeContraintsLandscape()
        }
    }
    
    internal override func orientationDidChangeLandscapeRight() {
        UIView.animate(withDuration: animatingDuration) {
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            
            self.makeContraintsLandscape()
        }
    }
}
