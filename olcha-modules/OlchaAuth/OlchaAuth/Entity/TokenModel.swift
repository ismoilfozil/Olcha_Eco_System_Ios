//
//  TokenModel.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import Foundation
public struct TokenModel: Codable {
    var token_type: String?
    var access_token: String?
    var refresh_token: String?
}
