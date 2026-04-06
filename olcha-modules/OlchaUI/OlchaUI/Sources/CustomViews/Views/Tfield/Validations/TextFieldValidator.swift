//
//  TFieldValidation.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 04/04/23.
//

import UIKit
public class TextFieldValidator {
    
    private var rules: [(String) -> ValidationResult] = []
    
    public func addRule(_ rule: @escaping (String) -> ValidationResult) {
        rules.append(rule)
    }
    
    public func validate(_ text: String) -> ValidationResult {
        for rule in rules {
            let result = rule(text)
            if case .invalid = result {
                return result
            }
        }
        return .valid
    }
}

public enum ValidationResult {
    case valid
    case invalid(String)
}

public extension ValidationResult {
    var isValid: Bool {
        if case .valid = self {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case let .invalid(message) = self {
            return message
        }
        return nil
    }
}

public typealias TextFieldValidationRule = (String) -> ValidationResult

public extension String {
    
    func validate(with rules: [TextFieldValidationRule]) -> ValidationResult {
        let validator = TextFieldValidator()
        rules.forEach { validator.addRule($0) }
        return validator.validate(self)
    }
    
}

public extension UITextField {
    
    func validate(with rules: [TextFieldValidationRule]) -> ValidationResult {
        guard let text = self.text else { return .invalid("empty".localized()) }
        return text.validate(with: rules)
    }
    
}
