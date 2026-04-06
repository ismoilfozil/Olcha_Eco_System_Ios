//
//  SuggestionApi.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaCore
import OlchaUtils

public enum SuggestionApi {
    case loadSuggestions
    case loadSuggestion(id: Int)
}

extension SuggestionApi: InvestBaseApi {
    public var baseURL: String {
        return Texts.url.common.base
    }
    
    public var path: String {
        switch self {
        case .loadSuggestions:
            return "news"
        case .loadSuggestion(let id):
            return "news/\(id)"
        }
    }
    
    public var queryItems: [URLQueryItem] {
        return []
    }
    
    public var method: RequestType {
        switch self {
        case .loadSuggestions, .loadSuggestion:
            return .get
        }
    }
    
    public var body: Data? {
        return nil
    }
}

