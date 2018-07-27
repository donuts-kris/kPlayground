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
    
    private var cameraIndex = -1

    func bind(_ viewModel: CameraViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        
        disposable += viewModel.captureButtonPressed.values.observe(on: UIScheduler()).observeValues { [weak self] in
            self?.photoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: viewModel)
        }
        
        disposable += viewModel.switchButtonPressed.values.observe(on: UIScheduler()).observeValues { [weak self] in
            guard let sSelf = self else { return }
            sSelf.nextCamera()
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
    
    @objc private func nextCamera() {
        let cameraIndex = (self.cameraIndex + 1) % self.cameras.count
        
        guard self.cameraIndex != cameraIndex else { return }
        
        if self.cameraIndex >= 0 {
            self.cameras[self.cameraIndex].disconnect()
        }
        self.photoOutput = self.cameras[cameraIndex].connect()
        
        self.cameraIndex = cameraIndex
    }
}

extension CameraView {
    override func didLoad() {
        self.cameras.forEach { camera in
            self.addSubview(camera)
        }
        
        self.nextCamera()
    }
}
