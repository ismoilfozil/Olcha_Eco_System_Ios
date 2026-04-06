//
//  AuthAPI.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import Foundation
import OlchaCore
import OlchaUtils

public protocol AuthAPIProtocol {
    func guestAuth() -> BaseSetterAPI
    func userAuth() -> BaseSetterAPI
    func refreshAuth() -> BaseSetterAPI
    func isSingleRequest() -> Bool
    func storeUserDevice(model: UserDevice) -> BaseAPI
    func deleteUserDevice(fcm_token: String) -> BaseAPI
}

public extension AuthAPIProtocol {
    func storeUserDevice(model: UserDevice) -> BaseAPI {
        return BaseOlchaAuthApi(path: "user-device",
                                version: Texts.url.getVersion(1),
                                method: .post,
                                body: model,
                                headers: OlchaAuthHeader.ecoShared,
                                baseURL: Texts.url.common.base)
    }
    
    func deleteUserDevice(fcm_token: String) -> BaseAPI {
        let body: [String: String] = ["token": fcm_token]
        return BaseOlchaAuthApi(path: "device-delete",
                                version: Texts.url.getVersion(1),
                                method: .post,
                                body: body,
                                headers: OlchaAuthHeader.ecoShared,
                                baseURL: Texts.url.common.base)
    }
}

public class AuthAPI: AuthAPIProtocol {
    
    public func guestAuth() -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "oauth/token",
                                   version: Texts.url.getVersion(2),
                                   method: .post,
                                   body: AuthModel())
        return api
    }
    
    public func userAuth() -> OlchaCore.BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "oauth/token",
                                   version: Texts.url.getVersion(2),
                                   method: .post,
                                   body: UserAuthToken())
        return api
    }
    
    public func refreshAuth() -> OlchaCore.BaseSetterAPI {
        let body = RefreshToken()
        let api = BaseOlchaAuthApi(path: "oauth/token",
                                   version: Texts.url.getVersion(2),
                                   method: .post,
                                   body: body)
        return api
    }
    
    public func isSingleRequest() -> Bool {
        return false
    }
}
