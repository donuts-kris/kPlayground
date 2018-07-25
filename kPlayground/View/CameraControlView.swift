//
//  CameraControlView.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/24.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SnapKit

class CameraControlView: AutoRotateView {
    
    private unowned var viewModel: CameraViewModel
    
    private lazy var captureButton: UIButton = {
        let button = UIButton()
        button.setTitle("o", for: .normal)
        button.setTitleColor(.white, for: .normal)
        //button.reactive.pressed = CocoaAction(self.viewModel.captureButtonPressed, input)
        return button
    }()
    
    private lazy var modeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Photo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("x", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.reactive.pressed = CocoaAction(self.viewModel.closeButtonPressed)
        return button
    }()
    
    convenience init(_ viewModel: CameraViewModel) {
        self.init(_: viewModel, frame: CGRect.zero)
    }
    
    private init(_ viewModel: CameraViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        self.addSubview(captureButton)
        self.addSubview(modeButton)
        self.addSubview(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CameraControlView {
    
    override func updateConstraints() {
        self.captureButton.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        self.modeButton.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        self.closeButton.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        self.orientationDidChange()
        
        super.updateConstraints()
    }
}
