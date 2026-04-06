//
//  PasswordRequest.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import Foundation
public struct PasswordRenewRequest: Codable {
    let password: String
    let password_confirmation: String
    let phone: String
    let code: String
}

public struct PasswordEditRequest: Codable {
    let password: String
    let password_confirmation: String
}
