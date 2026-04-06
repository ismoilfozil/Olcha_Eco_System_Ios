//
//  RefreshModel.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import Foundation
struct RefreshToken: Codable {
    var refresh_token: String = AuthGlobalDefaults.refresh_token ?? ""
    var client_id: String = AuthTexts.client_ID
    var client_secret: String = AuthTexts.client_secret
    var grant_type: String = AuthTexts.refresh_token
}

struct UserAuthToken: Codable {
    var refresh_token: String = AuthGlobalDefaults.refresh_token ?? ""
    var client_id: String = AuthTexts.client_ID
    var client_secret: String = AuthTexts.client_secret
    var grant_type: String = AuthGlobalDefaults.getClientType()
}
