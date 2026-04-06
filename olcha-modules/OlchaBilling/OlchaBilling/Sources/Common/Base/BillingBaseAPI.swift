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
import OlchaAuth
public class BillingHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    public static func headers() -> BillingHeader {
        let items: HTTPHeaders = [
            "ClientModel": "ios",
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language" : String.getAppLanguage(),
            "Authorization" : AuthGlobalDefaults.getToken(),
//            "organization": organization.rawValue
        ]
        
        return BillingHeader(items: items)
    }
}


public class BaseBillingApi: BaseSetterAPI {
    
    public override init(
        path: String,
        version: String = Texts.url.getVersion(1),
        method: RequestType,
        queryItems: [URLQueryItem] = [],
        body: Codable? = nil,
        params: [String : String] = [:],
        headers: ApiHeader,
        baseURL: String = Texts.url.billing.base
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

