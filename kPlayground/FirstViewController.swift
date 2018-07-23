//
//  FirstViewController.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/23.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: ViewController {

    private lazy var button : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        return button
    }()
    
    private var captureSession = AVCaptureSession()
    
    private var currentCamera : AVCaptureDevice?
    private var rearCamera : AVCaptureDevice?
    private var frontCamera : AVCaptureDevice?
    
    private var photoOutput = AVCapturePhotoOutput()

    private var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    
    @objc private func buttonClicked() {
        navigateToSecondVC()
    }
    
    private func navigateToSecondVC() {
        let vc = SecondViewController()
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    private func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    private func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        devices.forEach { device in
            if device.position == .back {
                rearCamera = device
            }
            else if device.position == .front {
                frontCamera = device
            }
            
            currentCamera = rearCamera
        }
    }
    
    private func setupInputOutput(){
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput)
        }
        catch {
            print(error)
        }
    }
    
    private func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = .resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = .portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    private func startRunningCaptureSession(){
        captureSession.startRunning()
    }
}

extension FirstViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
}
