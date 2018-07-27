//
//  CameraViewController.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/23.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation
import ReactiveSwift

class CameraViewController: ViewController {
    
    private lazy var viewModel = {
        return CameraViewModel()
    }()
    
    //todo
    private lazy var cameraView : CameraView = {
        return CameraView()//(frame: CGRect.screenIgnoreOrientation)
    }()
    
    private lazy var cameraControlView = {
        return CameraControlView()
    }()
    
    private func bind(_ viewModel: CameraViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        
        disposable += self.cameraView.bind(viewModel)
        
        disposable += self.cameraControlView.bind(viewModel)
        
        disposable += viewModel.closeButtonPressed.values.observe(on: UIScheduler()).observeValues { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        disposable += viewModel.photoSignal.observe(on: UIScheduler()).observeValues { [weak self] value in
            guard let value = value else { return }
            
            let viewController = PhotoViewController(value)
            self?.present(viewController, animated: true)
        }
        
        return disposable
    }
}

extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(cameraView)
        self.view.addSubview(cameraControlView)
        
        self.disposable += self.bind(self.viewModel)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
