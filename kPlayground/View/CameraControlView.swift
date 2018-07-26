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
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var switchButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("x", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    func bind(_ viewModel: CameraViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        
        self.captureButton.reactive.pressed = CocoaAction(viewModel.captureButtonPressed)
        self.closeButton.reactive.pressed = CocoaAction(viewModel.closeButtonPressed)
        
        disposable += viewModel.mode.producer.observe(on: UIScheduler()).skipRepeats().startWithValues { [weak self] value in
            self?.modeButton.setTitle(value.rawValue, for: .normal)
        }
        
        disposable += self.modeButton.reactive.controlEvents(.touchDown).observe(on: UIScheduler()).observeValues { _ in
            viewModel.mode.value.toggle()
        }
        
        disposable += self.switchButton.reactive.controlEvents(.touchDown).observe(on: UIScheduler()).observeValues { _ in
            viewModel.source.value.toggle()
        }
        
        return disposable
    }
}

extension CameraControlView {
    
    override func didLoad() {
        self.addSubview(self.captureButton)
        self.captureButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        self.addSubview(self.modeButton)
        self.modeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        self.addSubview(self.switchButton)
        self.switchButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(65)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
}
