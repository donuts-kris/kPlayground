//
//  FirstViewController.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/23.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

class FirstViewController: ViewController {

    private lazy var button : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    @objc func buttonClicked() {
        navigateToSecondVC()
    }
    
    
    func navigateToSecondVC() {
        let vc = SecondViewController()
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
