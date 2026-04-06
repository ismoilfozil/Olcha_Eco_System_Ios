//
//  AuthType.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 03/10/23.
//

import Foundation
import OlchaCore

public enum AuthType {
    case mobile
    case auth
    
    public static func getLoginModel(data: Data?) -> LoginModel? {
        guard let data else { return nil }
        do {
            switch AuthTexts.type {
            case .mobile:
                let decodedData: LoginModel = try data.decodeData()
                return decodedData
            case .auth:
                let decodedData: BaseDecodingResponse<LoginModel, LoginModel> = try data.decodeData()
                return decodedData.data
            }
        } catch {
            return nil
        }
    }
    
    public static var authApi: AuthAPIProtocol {
        switch AuthTexts.type {
        case .mobile:
            return OldOlchaAuthAPI()
        case .auth:
            return AuthAPI()
        }
    }
}
