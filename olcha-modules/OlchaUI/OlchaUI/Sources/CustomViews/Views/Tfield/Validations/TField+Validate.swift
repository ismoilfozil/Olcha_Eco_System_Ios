//
//  TField+Validate.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 10/08/23.
//

import Foundation
public extension TField {
    @discardableResult
    func validate(errors: [String: [String]]?) -> Bool {
        guard let errors = errors,
              let messages = errors[field_tag] else { return false }
        errorStyle(messages.first ?? " - ")
        return true
    }
    
    func append(rule: @escaping TextFieldValidationRule) {
        rules.append(rule)
    }
}
