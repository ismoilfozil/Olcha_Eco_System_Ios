//
//  ProfileAPI.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 24/05/23.
//


import Foundation
import OlchaCore
import OlchaUtils


public protocol ProfileAPIProtocol {
    func user() -> BaseSetterAPI
    func editUser(model: User) -> BaseSetterAPI
    func deleteUser() -> BaseSetterAPI
}

public class ProfileAPI: ProfileAPIProtocol {
    public func user() -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "user/profile",
                                   version: Texts.url.getVersion(1),
                                   method: .get)
        return api
    }
    
    public func editUser(model: User) -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "user/profile",
                                   version: Texts.url.getVersion(1),
                                   method: .post,
                                   body: model)
        return api
    }
    
    public func deleteUser() -> BaseSetterAPI {
        let api = BaseOlchaAuthApi(path: "user/profile/delete-with-review",
                                   version: Texts.url.getVersion(1),
                                   method: .delete)
        return api
    }
}
