//
//  NewsAPI.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/03/23.
//

import Foundation
import OlchaCore
public enum NewsAPI {
    case news(page: Int)
}

extension NewsAPI: BaseOlchaPayApi {
    public var path: String {
        switch self {
        case .news:
            return "news/"
        }
    }
    
    public var method: RequestType {
        switch self {
        case .news:
            return .get
        }
    }
    
    public var body: Data? {
        var data: Data?
        switch self {
        default: break
        }
        return data
    }
}
