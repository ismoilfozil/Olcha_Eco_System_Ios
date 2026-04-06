//
//  NasiyaBaseAPI.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import Foundation
import OlchaCore
import OlchaUtils
import Alamofire
import OlchaAuth

public class CommonHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    public static func headers(
        organization: Organization = .none,
        version: String? = nil
    ) -> CommonHeader {
        let language = String.getAppLanguage() == "en" ? "oz" : String.getAppLanguage()
        var items: HTTPHeaders = [
            "ClientModel": "ios",
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": language,
            "Authorization" : AuthGlobalDefaults.getToken(),
            Organization.key: organization.value,
            "Accept-Language" : String.getAppLanguage()
        ]
        if let version {
            items["ClientVersion"] = version
        }
        return CommonHeader(items: items)
    }
}

public class BaseCommonApi: BaseSetterAPI {
    public override init(path: String,
                         version: String = Texts.url.getVersion(1),
                         method: RequestType,
                         queryItems: [URLQueryItem] = [],
                         body: Codable? = nil,
                         params: [String : String] = [:],
                         headers: ApiHeader = CommonHeader.headers(),
                         baseURL: String = Texts.url.common.base) {
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

