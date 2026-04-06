//
//  BaseErrorType.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 18/03/23.
//

import Foundation

open class BaseErrorType {
    public var message: String?
    public var errors: ValidationErrors?
    
    public init(message: String? = nil,
                errors: ValidationErrors? = nil) {
        self.message = message
        self.errors = errors
    }
}

