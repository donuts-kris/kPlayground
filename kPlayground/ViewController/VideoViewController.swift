//
//  VideoViewController.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/31.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: ViewController {

    private lazy var player = {
        return AVPlayer()
    }()
    
    private lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        return playerLayer
    }()

    init(_ videoURL: URL) {
        super.init()
        
        let playerItem = AVPlayerItem(url: videoURL)
        self.player.replaceCurrentItem(with: playerItem)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VideoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.insertSublayer(self.playerLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.player.play()
    }
}
