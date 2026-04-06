//
//  InvestBaseAPI.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaCore
import OlchaUtils
import Alamofire
import OlchaAuth

public class InvestHeader: ApiHeader {
    
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    static var shared : InvestHeader {
        let items: HTTPHeaders = [
            "ClientModel": "ios",
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization" : AuthGlobalDefaults.getToken(),
            "organization": "olcha-invest",
            "Accept-Language": String.getAppLanguage()
        ]
        return InvestHeader(items: items)
    }
    
}

public protocol InvestBaseApi: BaseAPI {}

extension InvestBaseApi {
    public var baseURL: String { Texts.investUrl.base }
    public var version: String { Texts.url.getVersion(1) }
    public var headers: ApiHeader { InvestHeader.shared }
    public var queryItems: [URLQueryItem] { [] }
    public var params: [String : String] { [:] }
    
    public func encode<T: Codable>(_ model: T) -> Data? {
        return try? JSONEncoder().encode(model)
    }
}
