//
//  PhotoViewController.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/25.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

class PhotoViewController: ViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(self.saveButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("x", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init(_ image: UIImage) {
        super.init()
        
        self.imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func saveButtonPressed(sender: UIButton!) {
        guard let image = self.imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveCompletion), nil)
    }
    
    @objc private func saveCompletion(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        var alertController: UIAlertController?
        
        if let error = error {
            alertController = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
        }
        else {
            alertController = UIAlertController(title: "Saved succesfully", message: "Photo saved", preferredStyle: .alert)
        }
        
        if let alertController = alertController {
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alertController, animated: true)
        }
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
        
        self.view.addSubview(saveButton)
        self.saveButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        self.view.addSubview(closeButton)
        self.closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
}
