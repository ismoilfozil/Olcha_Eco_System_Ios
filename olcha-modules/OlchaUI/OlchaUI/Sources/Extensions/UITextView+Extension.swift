//
//  UITextView+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/08/22.
//


import UIKit
public extension UITextView {
    func disable() {
        isSelectable = false
        isEditable = false
        isScrollEnabled = false
        isUserInteractionEnabled = false
    }
}
