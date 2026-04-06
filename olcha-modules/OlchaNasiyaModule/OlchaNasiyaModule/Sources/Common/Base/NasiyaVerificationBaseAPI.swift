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
public class NasiyaVerificationBaseHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    public static var shared : NasiyaVerificationBaseHeader {
        let items: HTTPHeaders = [
            "ClientModel": "ios",
            "Content-Type": "application/json",
            "Authorization" : AuthGlobalDefaults.getToken(),
            "Accept-Language" : String.getAppLanguage()
        ]
        return NasiyaVerificationBaseHeader(items: items)
    }
}

public class NasiyaVerificationBaseAPI: BaseSetterAPI {
    public override init(
        path: String,
        version: String = Texts.url.getVersion(2),
        method: RequestType,
        queryItems: [URLQueryItem] = [],
        body: Codable? = nil,
        params: [String : String] = [:],
        headers: ApiHeader = NasiyaVerificationBaseHeader.shared,
        baseURL: String = Texts.url.nasiya.base
    ) {
        super.init(path: path,
                   version: version,
                   method: method,
                   queryItems: queryItems,
                   params: params,
                   headers: headers,
                   baseURL: baseURL)
    }
}


