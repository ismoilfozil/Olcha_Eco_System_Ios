//
//  BaseNetworkOptions.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/06/22.
//

import OlchaAuth
import Alamofire
import UIKit
import OlchaCore
import OlchaUtils

public class OlchaMarketSimpleHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    static var shared : OlchaMarketSimpleHeader {
        let items: HTTPHeaders = [
            "Authorization": AuthGlobalDefaults.getToken(),
            "Accept-Language": String.getAppLanguage(),///ru,uz,oz
            "ClientModel" : "ios",
            "key": OlchaGlobalDefaults.cart_key ?? "",
            "favorite-key": OlchaGlobalDefaults.favorite_key ?? "",
            "comparison-key": OlchaGlobalDefaults.compare_key ?? ""
        ]
        return OlchaMarketSimpleHeader(items: items)
    }
}

public class OlchaMarketRefreshHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    static var shared : OlchaMarketRefreshHeader {
        let items: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept-Language": String.getAppLanguage(),///ru,uz,oz
            "ClientModel" : "ios",
            "key": OlchaGlobalDefaults.cart_key ?? "",
            "favorite-key": OlchaGlobalDefaults.favorite_key ?? "",
            "comparison-key": OlchaGlobalDefaults.compare_key ?? ""
        ]
        return OlchaMarketRefreshHeader(items: items)
    }
}

public class OlchaMarketEmptyHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    static var shared : OlchaMarketEmptyHeader {
        let items: HTTPHeaders = []
        return OlchaMarketEmptyHeader(items: items)
    }
}

public protocol OlchaMarketAPI: BaseAPI {
    
}

extension OlchaMarketAPI {
    public var baseURL: String { Texts.url.olcha.base }
    public var headers: ApiHeader { OlchaMarketSimpleHeader.shared }
    public var version: String { Texts.url.getVersion(2) }
    public var params: [String : String] { [:] }
    public var queryItems: [URLQueryItem] { [] }
}
