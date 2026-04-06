//
//  BaseViewController+Placeholder.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 16/09/22.
//

import UIKit
extension BaseViewController {
    
    
    //MARK: - Placeholder style
    
    func disablePlaceholder() {
        placeholder.isHidden = true
        placeholder.isUserInteractionEnabled = false
    }
    
    func enablePlaceholder() {
        placeholder.isHidden = false
        placeholder.isUserInteractionEnabled = true
    }
    
    func placeholderButton(observer: (() -> Void)?) {
        placeholder.mainButtonClick(observer: observer)
    }
    
}

enum PageType {
    case push
    case modal
}
