//
//  Bool+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/01/23.
//

import UIKit
public extension Bool {
    static func formatForPrice(_ textField: UITextField, _ string: String) -> Bool {
        defer {
            textField.sendActions(for: .editingChanged);
        }
        let formatter = Formatter.withSeparator
        if let groupingSeparator = formatter.groupingSeparator {
            if string == groupingSeparator {
                return true
            }
            
            if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                
                if string.isEmpty {
                    totalTextWithoutGroupingSeparators.removeLast()
                }
                
                if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparators),
                   let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {

                    textField.text = formattedText
                    return false
                }
            }
        }
        return true
    }
}
