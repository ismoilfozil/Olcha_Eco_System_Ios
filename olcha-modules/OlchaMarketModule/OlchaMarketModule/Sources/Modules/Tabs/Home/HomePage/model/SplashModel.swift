//
//  SplashModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 1/11/21.
//

import Foundation
public struct SplashModel : Codable {
    var access_token: String?
    var expires_in: Int?
    var token_type: String?
    var refresh_token: String?
}
