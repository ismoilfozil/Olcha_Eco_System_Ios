//
//  OlchaPayNetwork.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/01/23.
//

import Foundation
import OlchaCore
import OlchaUtils
import Alamofire
import OlchaAuth
public class OlchaPayHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    static var shared : OlchaPayHeader {
        let username = "olchapay"
        let password = "olcha@2022"
        let loginString = "\(username):\(password)"

        guard let loginData = loginString.data(using: .utf8) else {
            return OlchaPayHeader(items: [])
        }
        let base64LoginString = loginData.base64EncodedString()
        let items: HTTPHeaders = [
            "Authorization" : AuthGlobalDefaults.getToken(),
//            "Authorization": "Basic \(base64LoginString)"
            "Accept-Language": String.getAppLanguage()
        ]
        return OlchaPayHeader(items: items)
    }
}

public protocol BaseOlchaPayApi: BaseAPI {}

extension BaseOlchaPayApi {
    public var baseURL: String { Texts.url.pay.base }
    public var version: String { Texts.url.getVersion() }
    public var headers: ApiHeader { OlchaPayHeader.shared }
    public var queryItems: [URLQueryItem] { [] }
    public var params: [String : String] { [:] }
    
    public func encode<T: Codable>(_ model: T) -> Data? {
        var data: Data?
        do {
            data = try JSONEncoder().encode(model)
        } catch {}
        return data
    }
}


///
///Example Profile API
///
/*
enum ProfileAPI {
    case user
    case guest
}

extension ProfileAPI: BaseOlchaPayApi {
    var path: String {
        switch self {
        case .user:
            return "user"
        case .guest:
            return "guest"
        }
    }
    
    var method: RequestType {
        switch self {
        case .user:
            return .get
        case .guest:
            return .post
        }
    }
    
    var body: Data? {
        switch self {
        case .user:
            return nil
        case .guest:
            return nil
        }
    }
}
*/

