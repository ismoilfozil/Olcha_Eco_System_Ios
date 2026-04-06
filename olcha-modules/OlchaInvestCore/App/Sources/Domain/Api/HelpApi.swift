//
//  HelpApi.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaCore

public enum HelpApi {
    case storeFeedback(investorId: Int, message: String)
}

extension HelpApi: InvestBaseApi {
    public var path: String {
        switch self {
        case .storeFeedback:
            return "investors-contracts/feedback"
        }
    }
    
    public var queryItems: [URLQueryItem] {
        return []
    }
    
    public var method: RequestType {
        switch self {
        case .storeFeedback:
            return .post
        }
    }
    
    public var body: Data? {
        switch self {
        case .storeFeedback(let investorId, let message):
            let request: [String: Any] = [
                "investor_id": investorId,
                "content": message
            ]
            return try? JSONSerialization.data(withJSONObject: request)
        }
    }
}
