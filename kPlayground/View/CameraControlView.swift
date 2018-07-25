//
//  CameraControlView.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/24.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class CameraControlView: AutoRotateView {

    private lazy var captureButton: UIButton = {
        let button = UIButton()
        button.setTitle("o", for: .normal)
        button.setTitleColor(.white, for: .normal)
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
        return button
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        self.addSubview(self.captureButton)
        self.addSubview(self.modeButton)
        self.addSubview(self.closeButton)
    }
    
    func bind(_ viewModel: CameraViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        
        captureButton.reactive.pressed = CocoaAction(viewModel.captureButtonPressed)
        closeButton.reactive.pressed = CocoaAction(viewModel.closeButtonPressed)
        
        return disposable
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
