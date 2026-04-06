//
//  TFieldCardNumberValidation.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 20/02/23.
//

import UIKit
public class TFieldCardNumberMask: TFieldMask {
    public func execute(textField: UITextField, range: NSRange, replacingText: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: replacingText) as String
        
        textField.text = lastText.format("nnnn nnnn nnnn nnnn", oldString: text)
        return false
    }
    
}
