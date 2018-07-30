//
//  KDebug.swift
//  kPlayground
//
//  Created by s.kananat on 2018/07/30.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import ReactiveSwift

@objc class KDebug : NSObject {
    
    public static let shared = {
        return KDebug()
    }()
    
    private lazy var debugView = {
        return KDebugView()
    }()
    
    private override init() {
        super.init()
    }
    
    class func log(_ message: String) {
        KDebug.shared.debugView.log(message)
    }
}

fileprivate class KDebugView: View {

    private lazy var textView: UITextView = {
        let textView = UITextView()
        
        textView.delegate = self
        
        textView.isEditable = false
        textView.isSelectable = false
        
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = UIColor.red
        textView.backgroundColor = UIColor.clear
        
        textView.text = ""

        return textView
    }()
    
    fileprivate init() {
        super.init(frame: CGRect.screen)
        
        self.layer.zPosition = .greatestFiniteMagnitude
        self.addSubview(self.textView)
        
        self.sleep()
        
        let application = UIApplication.shared
        
        if self.superview != nil {
            self.scrollToBottom()
        }
        else if let window = application.keyWindow {
            window.addSubview(self)
            
            self.scrollToBottom()
        }
        else if let delegate = application.delegate as? AppDelegate {
            self.disposable += delegate.reactive.signal(for: #selector(AppDelegate.applicationDidBecomeActive)).take(first: 1).observe(on: UIScheduler()).observeValues { [weak self] _ in
                guard let sSelf = self, let window = application.keyWindow else { return }

                window.addSubview(sSelf)
                
                sSelf.scrollToBottom()
                sSelf.wake()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.disposable.dispose()
    }
    
    fileprivate func log(_ message: String) {
        #if DEBUG

            if self.textView.text != "" {
                self.textView.text = self.textView.text + "\n"
            }
            
            self.textView.text = self.textView.text + message
            
            self.scrollToBottom()
            
            self.wake()
        #endif
    }
    
    private func wake() {
        #if DEBUG
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.sleep), object: nil)
            
            self.isHidden = false
            
            self.perform(#selector(self.sleep), with: nil, afterDelay: 3.5)
            
        #endif
    }
    
    @objc private func sleep() {
        #if DEBUG
            
            self.isHidden = true
            
        #endif
    }
    
    private func remakeConstraints() {
        guard self.superview != nil && self.textView.superview != nil else { return }
        
        self.snp.remakeConstraints { make in
            //guard self.superview != nil else { return }
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(80)
        }
        
        self.textView.snp.remakeConstraints { make in
            //guard self.textView.superview != nil else { return }
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            let textCount = self.textView.text.count
            
            if textCount > 0 {
                let bottom = NSMakeRange(textCount - 1, 1)
                
                self.textView.scrollRangeToVisible(bottom)
            }
            
            self.remakeConstraints()
        }
    }
}

extension KDebugView : UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.wake()
    }
}

