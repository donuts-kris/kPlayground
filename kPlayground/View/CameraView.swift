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
    
    private lazy var cameras = {
        return self.findCameras()
    }()
    
    private var photoOutput: AVCapturePhotoOutput?
    
    private var cameraIndex = 0

    func bind(_ viewModel: CameraViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        
        disposable += viewModel.captureButtonPressed.values.observe(on: UIScheduler()).observeValues { [weak self] in
            
            self?.photoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: viewModel)
        }
        
        disposable += viewModel.switchButtonPressed.values.observe(on: UIScheduler()).observeValues { [weak self] in
            guard let sSelf = self else { return }
            sSelf.switchCamera()
            viewModel.source.swap(sSelf.cameras[sSelf.cameraIndex].name)
        }
        
        viewModel.source.swap(self.cameras[self.cameraIndex].name)
        
        return disposable
    }
    
    private func findCameras() -> [SingleCameraView] {
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
    }
    
    @objc private func switchCamera() {
        
        let cameraIndex = (self.cameraIndex + 1) % self.cameras.count
        guard self.cameraIndex != cameraIndex else { return }
        
        let previousCamera = self.disconnectCamera()
        
        self.cameraIndex = cameraIndex
        
        let nextCamera = self.connectCamera()
        
        self.animate(previousCamera, nextCamera)
    }
    
    private func disconnectCamera() -> SingleCameraView? {
        guard self.cameraIndex >= 0 && self.cameraIndex < self.cameras.count else { return nil }
        
        let camera = self.cameras[self.cameraIndex]
        camera.disconnect()
        
        return camera
    }
    
    private func connectCamera() -> SingleCameraView? {
        guard self.cameraIndex >= 0 && self.cameraIndex < self.cameras.count else { return nil }

        let camera = self.cameras[self.cameraIndex]
        self.photoOutput = camera.connect()
        
        return camera
    }
    
    private func animate(_ previousCamera : SingleCameraView?, _ nextCamera : SingleCameraView?) {
        guard let previousCamera = previousCamera, let nextCamera = nextCamera else { return }
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            
        UIView.transition(with: previousCamera, duration: 0.6, options: transitionOptions, animations: nil)
        UIView.transition(with: nextCamera, duration: 0.6, options: transitionOptions, animations: nil)
    }
}

extension CameraView {
    override func didLoad() {
        self.cameras.forEach { camera in
            self.addSubview(camera)
        }
        
        _ = self.connectCamera()
    }
}
