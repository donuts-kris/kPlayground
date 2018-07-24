//
//  CameraViewController.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/23.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: ViewController {
    
    private lazy var cameraView: CameraView = {
        let cameraView = CameraView()
        return cameraView
    }()
    
    private lazy var cameraControlView: CameraControlView = {
        let cameraControlView = CameraControlView(self)
        return cameraControlView
    }()
}

extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(cameraView)
        self.view.addSubview(cameraControlView)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
