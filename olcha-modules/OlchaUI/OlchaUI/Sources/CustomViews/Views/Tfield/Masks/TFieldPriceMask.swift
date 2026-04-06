//
//  TFieldPriceValidation.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 20/02/23.
//

import UIKit
public class TFieldPriceMask: TFieldMask {
    
    public func execute(textField: UITextField, range: NSRange, replacingText: String) -> Bool {
        guard let text = textField.text else { return false }
        return .formatForPrice(textField, replacingText)
    }
    
}


