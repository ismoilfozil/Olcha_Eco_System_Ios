//
//  LoginAuthModel.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import Foundation
public struct LoginAuthModel: Codable {
    public let username: String//phone
    public let password: String
    public var client_id: String
    public var client_secret: String
    public var grant_type: String
}
