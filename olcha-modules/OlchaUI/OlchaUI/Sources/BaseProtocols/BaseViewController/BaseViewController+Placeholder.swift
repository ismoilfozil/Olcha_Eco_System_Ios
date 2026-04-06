//
//  BaseViewController+Placeholder.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 18/05/23.
//

import UIKit
extension BaseViewController {
    //MARK: - Placeholder style
    
    public func disablePlaceholder() {
        UIView.transition(with: placeholder, duration: 0.1, options: [.transitionCrossDissolve]) {
            self.placeholder.isHidden = true
        }
        placeholder.isUserInteractionEnabled = false
    }
    
    public func enablePlaceholder() {
        UIView.transition(with: placeholder, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.placeholder.isHidden = false
        }
        placeholder.isUserInteractionEnabled = true
    }
    
    public func placeholderButton(observer: (() -> Void)?) {
        placeholder.mainButtonClick(observer: observer)
    }
}
