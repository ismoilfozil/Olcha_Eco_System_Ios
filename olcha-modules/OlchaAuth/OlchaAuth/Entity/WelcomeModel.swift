//
//  WelcomeModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/09/22.
//

import Foundation
public struct WelcomeData: Codable {
    public var exists: Bool?
}

public struct UserAuthModel: Codable {
//    var user: User?
    var token: LoginModel?
}
