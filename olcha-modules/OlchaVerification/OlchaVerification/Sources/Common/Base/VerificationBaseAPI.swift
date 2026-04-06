//
//  OlchaBankCardsBaseAPI.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 06/05/23.
//

import Foundation
import OlchaCore
import OlchaUtils
import Alamofire
import OlchaAuth

public class VerificationBaseHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    public static var shared : VerificationBaseHeader {
        let items: HTTPHeaders = [
            "Authorization" : AuthGlobalDefaults.getToken(),
            "Accept-Language" : String.getAppLanguage()
        ]
        return VerificationBaseHeader(items: items)
    }
}

public class VerificationBaseAPI: BaseSetterAPI {
    public override init(
        path: String,
        version: String = Texts.url.getVersion(2),
        method: RequestType,
        queryItems: [URLQueryItem] = [],
        body: Codable? = nil,
        params: [String : String] = [:],
        headers: ApiHeader = VerificationBaseHeader.shared,
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

public class MyIdBaseApi : BaseSetterAPI {
    public override init(
        path: String,
        version: String = Texts.url.getVersion(),
        method: RequestType,
        queryItems: [URLQueryItem] = [],
        body: Codable? = nil,
        params: [String : String] = [:],
        headers: ApiHeader = VerificationBaseHeader.shared,
        baseURL: String = Texts.url.nasiya.base
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

