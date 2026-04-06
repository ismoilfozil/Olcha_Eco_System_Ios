//
//  BaseValidatedError.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 15/08/23.
//

import Foundation
public struct BaseValidationErrors : Codable {
    public var code: String?
    public var validations: ValidationErrors?
}
