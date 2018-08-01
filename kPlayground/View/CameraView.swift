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
    
    private lazy var cameras: [SingleCameraView] = {
        var cameras: [SingleCameraView] = []
        self.devices.forEach { device in
            if device.position == .back, let camera = SingleCameraView(device, "Back") {
                cameras.append(camera)
            }
            else if device.position == .front, let camera = SingleCameraView(device, "Front") {
                cameras.append(camera)
            }
            else if let camera = SingleCameraView(device, "Unknown") {
                cameras.append(camera)
            }
        }
        return cameras
    }()
    
    private var cameraIndex = 0
    
    private var activeCamera: SingleCameraView? {
        guard self.cameraIndex >= 0 && self.cameraIndex < self.cameras.count else { return nil }

        return self.cameras[self.cameraIndex]
    }

    func bind(_ viewModel: CameraViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        
        self.cameras.forEach { camera in
            disposable += camera.bind(viewModel)
        }
        
        disposable += viewModel.captureButtonPressed.values.throttle(1.0, on: QueueScheduler.main).observe(on: UIScheduler()).observeValues { [weak self] in
            
            switch viewModel.mode.value {
            case .photo:
                self?.activeCamera?.capturePhoto(delegate: viewModel)

            case .video:
                viewModel.recording.swap(!viewModel.recording.value)
            }
        }
        
        disposable += viewModel.recording.producer.observe(on: UIScheduler()).startWithValues { [weak self] value in
            
            guard let camera = self?.activeCamera else { return }
            
            if value {
                camera.startRecording(delegate: viewModel)
            }
            else {
                camera.stopRecording()
            }
        }
        
        disposable += viewModel.switchButtonPressed.values.observe(on: UIScheduler()).observeValues { [weak self] in
            guard let sSelf = self, let currentCamera = sSelf.activeCamera else { return }
            
            sSelf.switchCamera()
            viewModel.source.swap(currentCamera.name)
        }
        
        return disposable
    }
    
    @objc private func switchCamera() {
        
        let cameraIndex = (self.cameraIndex + 1) % self.cameras.count
        guard self.cameraIndex != cameraIndex else { return }
        
        let previousCamera = self.activeCamera
        previousCamera?.setActive(false)
        
        self.cameraIndex = cameraIndex
        
        let camera = self.activeCamera
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
        
        self.activeCamera?.setActive(true)
    }
}
