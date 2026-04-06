//
//  Texts.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import Foundation
import OlchaUtils

public class AuthTexts {
    static let client_ID = "6"
    static let client_secret = "RnfliHduJAdJ5bcmDOp63WDu0uMjA0ZPYvirCnHD"
    static let refresh_token = "refresh_token"
    static let password = "password"
    static let client_credentials = "client_credentials"
    
    public static var type: AuthType {
        let parent = ModuleGeneratorHelper.shared.parentModule
        switch parent {
        case .olcha:
            return .mobile
        default:
            return .auth
        }
    }
}
