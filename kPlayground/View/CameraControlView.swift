//
//  CameraControlView.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/24.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import SnapKit

class CameraControlView: RotatableView {
    
    private unowned var vc: CameraViewController
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        return button
    }()
    
    convenience init(_ vc: CameraViewController) {
        self.init(vc, frame: CGRect.zero)
    }
    
    private init(_ vc: CameraViewController, frame: CGRect) {
        self.vc = vc
        super.init(frame: frame)
        
        self.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonClicked() {
        vc.dismiss(animated: false)
    }
}

extension CameraControlView {
    
    override func updateConstraints() {
        self.snp.remakeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}

extension CameraControlView {
    
    override func orientationDidChangePortrait() {
        
    }
    
    override func orientationDidChangePortraitUpsideDown() {
        
    }
    
    override func orientationDidChangeLandscapeLeft() {
        
    }
    
    override func orientationDidChangeLandscapeRight() {
        
    }
}
