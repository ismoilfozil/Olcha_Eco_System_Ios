//
//  OlchaBankCardsBaseAPI.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 06/05/23.
//

import Foundation


import Foundation
import OlchaCore
import OlchaUtils
import Alamofire
import OlchaAuth
public class BaseBankCardHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    public static var shared : BaseBankCardHeader {
        let items: HTTPHeaders = [

            "Authorization" : AuthGlobalDefaults.getToken(),
            "Accept-Language" : String.getAppLanguage()
            
        ]
        return BaseBankCardHeader(items: items)
    }
}

public class BaseBankCardAPI: BaseSetterAPI {
    public override init(
        path: String,
        version: String = Texts.url.getVersion(2),
        method: RequestType,
        queryItems: [URLQueryItem] = [],
        body: Codable? = nil,
        params: [String : String] = [:],
        headers: ApiHeader = BaseBankCardHeader.shared,
        baseURL: String = Texts.url.olcha.base
    ) {
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


