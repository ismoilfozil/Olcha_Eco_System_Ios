//
//  AuthModel.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import Foundation
public struct AuthModel: Codable {
    var client_id: String = AuthTexts.client_ID
    var client_secret: String = AuthTexts.client_secret
    var grant_type: String = AuthGlobalDefaults.getClientType()
}
