//
//  LoginAPI.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 13/04/23.
//

import Foundation
import OlchaCore
import OlchaUtils

public protocol LoginAPIProtocol {
    func isExist(model: String) -> BaseSetterAPI
    func login(model: LoginAuthModel) -> BaseSetterAPI
    func confirmCode(model: PhoneRequest) -> BaseSetterAPI
    func editPassword(model: PasswordEditRequest) -> BaseSetterAPI
    func resetPhone(model: PhoneCodeRequest) -> BaseSetterAPI
    func renewPassword(model: PasswordRenewRequest) -> BaseSetterAPI
    func registerPhone(model: PhoneCodeProtocol) -> BaseSetterAPI
    func isSingleRequest() -> Bool
}

public class LoginAPI: LoginAPIProtocol {
    public func isExist(model: String) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "user/exists/\(model)",
                                   version: Texts.url.getVersion(1),
                                   method: .get)
        return api
    }
    public func login(model: LoginAuthModel) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "oauth/token",
                                   version: Texts.url.getVersion(2),
                                   method: .post,
                                   body: model)
        return api
    }
    public func confirmCode(model: PhoneRequest) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "sendsms2",
                                   method: .post,
                                   body: model)
        return api
    }
    public func editPassword(model: PasswordEditRequest) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "editPassword",
                                   method: .post,
                                   body: model)
        return api
    }
    public func resetPhone(model: PhoneCodeRequest) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "password/checksms",
                                   method: .post,
                                   body: model)
        return api
    }
    public func renewPassword(model: PasswordRenewRequest) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "password/renew",
                                   method: .post,
                                   body: model)
        return api
    }
    public func registerPhone(model: PhoneCodeProtocol) -> BaseSetterAPI {
//
//        if let phoneCodeReferal = model as? PhoneCodeReferalRequest {
//            data = encode(phoneCodeReferal)
//        } else if let phoneCode = model as? PhoneCodeRequest {
//            data = encode(phoneCode)
//        }
        let api = BaseOlchaAuthApi(path: "register-with-sms",
                                   method: .post,
                                   body: model)
        return api
    }
    
    public func isSingleRequest() -> Bool {
        return false
    }
}
