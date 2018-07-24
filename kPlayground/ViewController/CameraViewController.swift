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

    
    
    private lazy var button : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.imageView?.image = UIImage(named: "camera")
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var cameraView : CameraView = {
        let cameraView = CameraView()
        return cameraView
    }()
    
    @objc private func buttonClicked() {
        //navigateToSecondVC()
    }
    
    /*
    private func navigateToSecondVC() {
        let vc = SecondViewController()
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
 */
}

extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        self.view.addSubview(cameraView)
        cameraView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
