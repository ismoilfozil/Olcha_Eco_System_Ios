//
//  BillingBaseAPI.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 21/06/23.
//

import Foundation
import OlchaCore
import OlchaUtils
import Alamofire

public class OlchaAuthHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    public static var shared : OlchaAuthHeader {
        
        let items: HTTPHeaders =  [
            "Authorization": AuthGlobalDefaults.getToken(),
            "Accept-Language": String.getAppLanguage()
        ]
        
        return OlchaAuthHeader(items: items)
    }
    
    public static var ecoShared: OlchaAuthHeader {
        let items: HTTPHeaders =  [
            "Authorization": AuthGlobalDefaults.getToken(),
            "Accept-Language": String.getAppLanguage(),
            "organization": Organization.ecoSystem.value,
        ]
        return OlchaAuthHeader(items: items)
    }
}

public class BaseOlchaAuthApi: BaseSetterAPI {
    
    public override init(
        path: String,
        version: String = Texts.url.getVersion(1),
        method: RequestType,
        queryItems: [URLQueryItem] = [],
        body: Codable? = nil,
        params: [String : String] = [:],
        headers: ApiHeader = OlchaAuthHeader.shared,
        baseURL: String = Texts.url.auth.base
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

