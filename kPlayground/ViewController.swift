//
//  ViewController.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/23.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift

class ViewController : UIViewController {
    
    private static let LOG_INFO : [LogInfo] = [.initialize, .viewWillAppear, .deinitialize]
    
    internal var disposable = CompositeDisposable()
    
    internal var longDescription : String {
        return super.description
    }
    
    internal var shortDescription : String {
        return "<\(String(describing: type(of: self)))>"
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
        
        if let initialize = ViewController.LOG_INFO.first(where: {$0 == .initialize}) {
            print("\(String(describing: self)) \(String(describing: initialize))")
        }
        
        ViewController.LOG_INFO.forEach { x in
            if let selector = x.selector {
                self.disposable += self.reactive.signal(for: selector).observeValues { [weak self] _ in
                    guard let sSelf = self else { return }
                    print("\(String(describing: sSelf)) \(String(describing: x))")
                }
            }
        }
    }
    
    deinit {
        if let deinitialize = ViewController.LOG_INFO.first(where: {$0 == .deinitialize}) {
            print("\(String(describing: self)) \(String(describing: deinitialize))")
        }
        
        disposable.dispose()
    }
}

extension ViewController {
    enum LogInfo : String, CustomStringConvertible {
        case initialize, deinitialize, viewDidLoad, viewWillAppear, viewDidAppear, viewWillDisappear, viewDidDisappear
        
        var selector : Selector? {
            switch self {
            case .viewDidLoad:
                return #selector(ViewController.viewDidLoad)
                
            case .viewWillAppear:
                return #selector(ViewController.viewWillAppear)
                
            case .viewDidAppear:
                return #selector(ViewController.viewDidAppear)
                
            case .viewWillDisappear:
                return #selector(ViewController.viewWillDisappear)
                
            case .viewDidDisappear:
                return #selector(ViewController.viewDidDisappear)
                
            default:
                return nil
            }
        }
        
        var description : String {
            if self == .initialize {
                return "init"
            }
            else if self == .deinitialize {
                return "deinit"
            }
            
            return self.rawValue
        }
    }
}

extension ViewController {
    override var description : String {
        return shortDescription
    }
}

