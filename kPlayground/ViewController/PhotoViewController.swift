//
//  PhotoViewController.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/25.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

class PhotoViewController: ViewController {
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("x", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init(_ image: UIImage) {
        super.init()
        
        self.imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeButtonPressed(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PhotoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(imageView)
        self.imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.view.addSubview(closeButton)
        self.closeButton.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
}
