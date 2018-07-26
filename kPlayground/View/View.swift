//
//  View.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/26.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import ReactiveSwift

internal class View: UIView {

    private let disposable = CompositeDisposable()
    
    private lazy var isOverriddenDidLoad = {
        return class_getInstanceMethod(object_getClass(self), #selector(self.didLoad)) != class_getInstanceMethod(View.self, #selector(View.didLoad))
    }()
    
    private lazy var isOverriddenWillAppear = {
        return class_getInstanceMethod(object_getClass(self), #selector(self.willAppear)) != class_getInstanceMethod(View.self, #selector(View.willAppear))
    }()
    
    private lazy var isOverriddenDidAppear = {
        return class_getInstanceMethod(object_getClass(self), #selector(self.didAppear)) != class_getInstanceMethod(View.self, #selector(View.didAppear))
    }()
    
    private lazy var isOverriddenWillDisappear = {
        return class_getInstanceMethod(object_getClass(self), #selector(self.willDisappear)) != class_getInstanceMethod(View.self, #selector(View.willDisappear))
    }()
    
    private lazy var isOverriddenDidDisappear = {
        return class_getInstanceMethod(object_getClass(self), #selector(self.didDisappear)) != class_getInstanceMethod(View.self, #selector(View.didDisappear))
    }()
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }

    deinit {
        self.disposable.dispose()
    }
    
    @objc dynamic internal func didLoad() { }
    @objc dynamic internal func willAppear() { }
    @objc dynamic internal func didAppear() { }
    @objc dynamic internal func willDisappear() { }
    @objc dynamic internal func didDisappear() { }
    
    private func findViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
    
extension View {
    override func didMoveToSuperview() {
        guard self.superview != nil else { return }
        
        self.didLoad()
        
        guard isOverriddenWillAppear || isOverriddenDidAppear || isOverriddenWillDisappear || isOverriddenDidDisappear, let viewController = self.findViewController() else { return }
        
        if isOverriddenWillAppear {
            self.disposable += viewController.reactive.signal(for: #selector(ViewController.viewWillAppear)).observe(on: UIScheduler()).observeValues { [weak self] value in
                self?.willAppear()
            }
        }
        
        if isOverriddenDidAppear {
            self.disposable += viewController.reactive.signal(for: #selector(ViewController.viewDidAppear)).observe(on: UIScheduler()).observeValues { [weak self] value in
                self?.didAppear()
            }
        }

        if isOverriddenWillDisappear {
            self.disposable += viewController.reactive.signal(for: #selector(ViewController.viewWillDisappear)).observe(on: UIScheduler()).observeValues { [weak self] value in
                self?.willDisappear()
            }
        }
        
        if isOverriddenDidDisappear {
            self.disposable += viewController.reactive.signal(for: #selector(ViewController.viewDidDisappear)).observe(on: UIScheduler()).observeValues { [weak self] value in
                self?.didDisappear()
            }
        }
    }
}
