//
//  LoyaltyAPI.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 06/07/24.
//

import Foundation
import OlchaCore
import OlchaUtils
public protocol LoyaltyAPIProtocol {
    func nextLevel() -> BaseAPI
    func getLevels() -> BaseAPI
    func getUserLevel() -> BaseAPI
}

public class LoyaltyAPI: LoyaltyAPIProtocol {
    public func nextLevel() -> BaseAPI {
        let api = BaseCommonApi(path: "next/level",
                                version: Texts.url.getVersion(2),
                                method: .get,
                                baseURL: Texts.url.cashback.base)
        return api
    }
    
    public func getLevels() -> BaseAPI {
        let api = BaseCommonApi(path: "levels",
                                version: Texts.url.getVersion(2),
                                method: .get,
                                baseURL: Texts.url.cashback.base)
        return api
    }
    
    public func getUserLevel() -> BaseAPI {
        let api = BaseCommonApi(path: "user/level",
                                version: Texts.url.getVersion(2),
                                method: .get,
                                baseURL: Texts.url.cashback.base)
        return api
    }
}
