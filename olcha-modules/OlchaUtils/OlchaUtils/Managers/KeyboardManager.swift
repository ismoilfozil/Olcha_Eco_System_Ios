//
//  KeyboardManager.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 25/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public final class KeyboardManager {
    
    private let notificationCenter = NotificationCenter.default
    
    public var keyboardWillShowObserver: ((CGFloat, TimeInterval) -> Void)?
    public var keyboardWillHideObserver: (() -> Void)?
    
    public init() {}
    
    public func startObservingKeyboard() {
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public func stopObservingKeyboard() {
        notificationCenter.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let timeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        keyboardWillShowObserver?(keyboardHeight, timeInterval)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardWillHideObserver?()
    }
}

