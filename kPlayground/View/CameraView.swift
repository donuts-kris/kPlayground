//
//  CameraView.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/24.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation
import Result
import ReactiveSwift

class CameraView: View {
    
    private lazy var devices: [AVCaptureDevice] = {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        return deviceDiscoverySession.devices
    }()
    
    private var cameras: [SingleCameraView] = []
    
    private var cameraIndex = 0
    
    private var camera: SingleCameraView? {
        guard self.cameraIndex >= 0 && self.cameraIndex < self.cameras.count else { return nil }

        return self.cameras[self.cameraIndex]
    }

    private func setupCameras(_ supportedModes: [CaptureMode], _ supportedPositions: [AVCaptureDevice.Position]) {
        self.devices
            .filter { device in supportedPositions.contains(device.position) }
            .sorted { device1, device2 in supportedPositions.index(of: device1.position)! < supportedPositions.index(of: device2.position)! }
            .forEach { device in
                let camera = SingleCameraView(device)
                cameras.append(camera)
        }
    }
    
    func bind(_ viewModel: CameraViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        
        self.setupCameras(viewModel.supportedModes, viewModel.supportedCameras)
        
        self.cameras.forEach { camera in
            disposable += camera.bind(viewModel)
        }
        
        disposable += viewModel.captureButtonPressed.values.throttle(1.0, on: QueueScheduler.main).observe(on: UIScheduler()).observeValues { [weak self] in
            
            guard let camera = self?.camera else { return }
            
            switch viewModel.mode.value {
            case .photo:
                camera.photo.capture(delegate: viewModel)

            case .video:
                viewModel.recording.swap(!viewModel.recording.value)
                
            case .none:
                break
            }
        }
        
        disposable += viewModel.recording.signal.observe(on: UIScheduler()).observeValues { [weak self] value in
            
            guard let camera = self?.camera else { return }
            
            if value {
                camera.video.capture(delegate: viewModel)
            }
            else {
                camera.video.endCapture()
            }
        }
        
        disposable += viewModel.switchButtonPressed.values.throttle(1.0, on: QueueScheduler.main).observe(on: UIScheduler()).observeValues { [weak self] in
            guard let sSelf = self else { return }
            
            sSelf.switchCamera()
            
            if let position = sSelf.camera?.position {
                viewModel.position.swap(position)
            }
        }
        
        return disposable
    }
    
    @objc private func switchCamera() {
        let cameraIndex = (self.cameraIndex + 1) % self.cameras.count
        guard self.cameraIndex != cameraIndex else { return }
        
        let previousCamera = self.camera
        previousCamera?.setActive(false)
        
        self.cameraIndex = cameraIndex
        
        let camera = self.camera
        camera?.setActive(true)
        
        guard let firstView = previousCamera, let secondView = camera else { return }
        CameraView.animate(firstView, secondView)
    }

    private static func animate(_ firstView: UIView, _ secondView: UIView) {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            
        UIView.transition(with: firstView, duration: 0.6, options: transitionOptions, animations: nil)
        UIView.transition(with: secondView, duration: 0.6, options: transitionOptions, animations: nil)
    }
}

extension CameraView {
    override func didLoad() {
        self.cameras.forEach { camera in
            self.addSubview(camera)
        }
        
        self.camera?.setActive(true)
    }
}
