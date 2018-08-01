//
//  CameraViewController.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/23.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import ReactiveSwift

class CameraViewController: ViewController {
    
    private lazy var viewModel: CameraViewModel = {
        let viewModel = CameraViewModel(self.supportedModes, self.supportedCameras)
        return viewModel
    }()
    
    private lazy var cameraView: CameraView = {
        let view = CameraView()
        return view
    }()
    
    private lazy var cameraControlView: CameraControlView = {
        let view = CameraControlView()
        return view
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
        
        disposable += viewModel.videoSignal.observe(on: UIScheduler()).observeValues { [weak self] value in
            guard let value = value else { return }

            let viewController = AVPlayerViewController()
            viewController.player = AVPlayer(url: value)
            self?.present(viewController, animated: true) {
                viewController.player!.play()
            }
        }
        
        return disposable
    }
    
    internal var supportedModes: [CaptureMode] {
        return [.photo, .video]
    }
    
    internal var supportedCameras: [AVCaptureDevice.Position] {
        return [.back, .front, .unspecified]
    }
}

extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.disposable += self.bind(self.viewModel)
        
        self.view.addSubview(self.cameraView)
        self.view.addSubview(self.cameraControlView)
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
