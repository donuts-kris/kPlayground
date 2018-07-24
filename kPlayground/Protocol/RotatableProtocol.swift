//
//  RotatableProtocol.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/24.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

@objc protocol RotatableProtocol {
    @objc optional func updateConstraitPortrait()
    @objc optional func updateConstraitPortraitUpsideDown()
    @objc optional func updateConstraitLandscapeLeft()
    @objc optional func updateConstraitLandscapeRight()
}
