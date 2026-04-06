//
//  BaseResponse+Extensions.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 15/08/23.
//

import Foundation
public extension BaseResponse {
    
    var validationErrors: BaseErrorType {
        if let errors = errors as? ValidationErrors {
            return BaseErrorType(message: error, errors: errors)
        } else if let errors = (errors as? BaseValidationErrors)?.validations {
            return BaseErrorType(message: error, errors: errors)
        }
        return BaseErrorType(message: error)
    }
    
    var baseError: BaseErrorType {
        return BaseErrorType(message: error)
    }
    
}
