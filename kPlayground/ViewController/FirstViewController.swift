//
//  FirstViewController.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/23.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

class FirstViewController: ViewController {

}

extension FirstViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        present(CameraViewController(), animated: false, completion: nil)
    }
}
