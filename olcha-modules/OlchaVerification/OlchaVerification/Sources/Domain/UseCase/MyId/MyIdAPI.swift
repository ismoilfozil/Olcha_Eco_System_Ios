//
//  VerificationAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/09/22.
//

import Foundation
import OlchaCore
import OlchaUtils

public protocol MyIdAPIProtocol {
    func checkExist(model: MyIdPassportModel) -> BaseAPI
    func uploadMyIdCode(model:MyIdCodeModel) -> BaseAPI
}

public class MyIdAPI: MyIdAPIProtocol {
    public init() {}
    
    public func checkExist(model: MyIdPassportModel) -> any OlchaCore.BaseAPI {
        let api = MyIdBaseApi(path: "myid/check-exists", method: .post)
        api.body = api.encode(model)
        return api
    }
    
    public func uploadMyIdCode(model: MyIdCodeModel) -> any OlchaCore.BaseAPI {
        let api = MyIdBaseApi(path: "myid/code", method: .post)
        api.body = api.encode(model)
        return api
    }
    
}
