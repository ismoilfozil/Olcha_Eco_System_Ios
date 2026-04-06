//
//  VersionAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/12/22.
//

import Foundation
import OlchaCore
import OlchaUtils
enum VersionAPI {
    case version
}
    
extension VersionAPI: OlchaMarketAPI {

    var version: String {
        switch self {
        case .version:
            return Texts.url.getVersion(3)
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .version:
            return [
                .init(name: "version", value: "\(MarketTexts.app_version)")
            ]
        }
    }
    
    #warning("set always current app version")
    var path: String {
        switch self {
        case .version:
            return "mobile-app-version-status"
        }
    }
    
    var method: RequestType {
        switch self {
            default: return .get
        }
    }
    
    var body: Data? {
        return nil
    }
    
    
}
