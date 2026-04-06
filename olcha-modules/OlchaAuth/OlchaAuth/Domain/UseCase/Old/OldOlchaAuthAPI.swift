//
//  OldOlchaAuthAPI.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 19/05/23.
//

import Foundation
import OlchaCore
import OlchaUtils

public class OldOlchaAuthAPI: AuthAPIProtocol, LoginAPIProtocol {
    
    public func guestAuth() -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "oauth/token",
                                   version: "",
                                   method: .post,
                                   body: AuthModel(),
                                   baseURL: Texts.url.olcha.base)
        return api
    }
    
    public func userAuth() -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "oauth/token",
                                   version: "",
                                   method: .post,
                                   body: UserAuthToken(),
                                   baseURL: Texts.url.olcha.base)
        return api
    }
    
    public func refreshAuth() -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "oauth/token",
                                   version: "",
                                   method: .post,
                                   body: RefreshToken(),
                                   baseURL: Texts.url.olcha.base)
        return api
    }
    
    public func isExist(model: String) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "user/exists/\(model)",
                                   version: Texts.url.getVersion(2),
                                   method: .get,
                                   baseURL: Texts.url.olcha.base)
        return api
    }
    
    public func login(model: LoginAuthModel) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "oauth/token",
                                   version: "",
                                   method: .post,
                                   body: model,
                                   baseURL: Texts.url.olcha.base)
        return api
    }
    
    public func confirmCode(model: PhoneRequest) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "sendsms2",
                                   version: Texts.url.getVersion(2),
                                   method: .post,
                                   body: model,
                                   baseURL: Texts.url.olcha.base)
        return api
    }
    
    public func editPassword(model: PasswordEditRequest) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "editPassword",
                                   version: Texts.url.getVersion(3),
                                   method: .post,
                                   body: model,
                                   baseURL: Texts.url.olcha.base)
        return api
    }
    
    public func resetPhone(model: PhoneCodeRequest) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "password/checksms",
                                   version: Texts.url.getVersion(),
                                   method: .post,
                                   body: model,
                                   baseURL: Texts.url.olcha.base)
        return api
    }
    
    public func renewPassword(model: PasswordRenewRequest) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "password/renew",
                                   version: Texts.url.getVersion(),
                                   method: .post,
                                   body: model,
                                   baseURL: Texts.url.olcha.base)
        return api
    }
    
    public func registerPhone(model: PhoneCodeProtocol) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "register-with-sms",
                                   version: Texts.url.getVersion(2),
                                   method: .post,
                                   body: model,
                                   baseURL: Texts.url.olcha.base)
        return api
    }
    
    public func isSingleRequest() -> Bool {
        return true
    }
}
