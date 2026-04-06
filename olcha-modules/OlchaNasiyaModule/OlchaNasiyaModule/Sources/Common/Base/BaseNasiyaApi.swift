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

public class NasiyaHeader: ApiHeader {
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    static var shared : NasiyaHeader {
        let items: HTTPHeaders = [
            "ClientModel": "ios",
            "Content-Type": "application/json",
            "Authorization" : AuthGlobalDefaults.getToken(),
            "Accept-Language" : String.getAppLanguage()
        ]
        return NasiyaHeader(items: items)
    }
}

public protocol BaseNasiyaApi: BaseAPI {}

extension BaseNasiyaApi {
    public var baseURL: String { Texts.url.nasiya.base }
    public var version: String { Texts.url.getVersion() }
    public var headers: ApiHeader { NasiyaHeader.shared }
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

