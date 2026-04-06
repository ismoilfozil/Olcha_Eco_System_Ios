//
//  OlchaBalanceAPI.swift
//  OlchaBalance
//
//  Created by Elbek Khasanov on 07/05/23.
//

import Foundation
import OlchaCore
import OlchaAuth
import OlchaUtils
import Alamofire
public class OlchaBalanceHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    public static var shared : OlchaBalanceHeader {
        let items: HTTPHeaders = [
            "Authorization" : AuthGlobalDefaults.getToken(),
            "Accept-Language" : String.getAppLanguage()
        ]
        return OlchaBalanceHeader(items: items)
    }
}

public class OlchaBalanceAPI: BaseSetterAPI {
    public override init(path: String,
                         version: String = Texts.url.getVersion(3),
                         method: RequestType,
                         queryItems: [URLQueryItem] = [],
                         body: Codable? = nil,
                         params: [String : String] = [:],
                         headers: ApiHeader = OlchaBalanceHeader.shared,
                         baseURL: String = Texts.url.olcha.base) {
        super.init(path: path,
                   version: version,
                   method: method,
                   queryItems: queryItems,
                   body: body,
                   params: params,
                   headers: headers,
                   baseURL: baseURL)
    }
}
