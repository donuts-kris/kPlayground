//
//  FirstViewController.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/23.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

class FirstViewController: ViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc private func buttonClicked() {
        self.present(CameraViewController(), animated: true, completion: nil)
        //self.present(TestViewController(), animated: true, completion: nil)
    }
}

extension FirstViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(button)
        self.button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
}
