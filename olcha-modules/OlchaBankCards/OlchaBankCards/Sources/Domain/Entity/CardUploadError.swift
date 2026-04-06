//
//  CardUploadError.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 15/08/23.
//

import Foundation
import OlchaCore

public struct CardUploadValidationError: Codable {
    public var code: String?
    public var validations: ValidationErrors?
}

public class CardUploadError: BaseErrorType {
    public var code: String?
    public init(code: String? = nil,
                message: String? = nil,
                errors: ValidationErrors? = nil) {
        self.code = code
        super.init(message: message, errors: errors)
    }
}
