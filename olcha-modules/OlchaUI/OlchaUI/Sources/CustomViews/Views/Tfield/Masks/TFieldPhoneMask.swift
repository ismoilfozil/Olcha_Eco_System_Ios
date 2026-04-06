//
//  TFieldPhoneValidation.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 20/02/23.
//

import UIKit

public class TFieldPhoneMask: TFieldMask {

    public func execute(textField: UITextField, range: NSRange, replacingText: String) -> Bool {
        guard let text = textField.text else { textField.sendActions(for: .editingChanged); return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: replacingText)
        textField.text = newString.formatPhoneNumber
        return false
    }
    
}
