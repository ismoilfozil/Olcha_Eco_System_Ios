//
//  UIViewController+TField+Validations.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 10/08/23.
//

import UIKit
import OlchaCore
public extension UIViewController {
    func validateFields(fields: [TField]?, error: BaseErrorType?) {
        var showAlertError = true
        if let errors = error?.errors,
           let fields = fields {
            for field in (fields) {
                let validated = field.validate(errors: errors)
                /// If only one validation comes, alert should not be shown
                if validated {
                    showAlertError = false
                }
            }
        }
        
        if showAlertError {
            showError(text: error?.message)
        }
    }
    /// - This group for `textfields` which shows error in the last field;
    func validateGroupedFields(fields: [TField]?, error: BaseErrorType?) {
        guard
            let fields = fields,
            let lastField = fields.last,
            let errors = error?.errors,
            lastField.validate(errors: errors)
        else {
            showError(text: error?.message)
            return
        }
     
        for field in fields {
            field.errorStyle()
        }
        
        lastField.validate(errors: errors)
    }
}
