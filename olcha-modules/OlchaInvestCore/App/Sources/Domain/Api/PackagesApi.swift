//
//  PackagesApi.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaCore

public enum PackagesApi {
    case packages(page: Int)
    case package(id: Int)
    case term(id: Int)
}

extension PackagesApi: InvestBaseApi {
    public var path: String {
        switch self {
        case .packages:
            return "investments"
        case .package(let id):
            return "investments/\(id)"
        case .term(let id):
            return "investments/terms/\(id)"
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .packages(let page):
            return [
                .init(name: "page", value: page.string)
            ]
        case .package:
            return []
        case .term:
            return []
        }
    }
    
    public var method: RequestType {
        switch self {
        case .packages:
            return .get
        case .package:
            return .get
        case .term:
            return .get
        }
    }
    
    public var body: Data? {
        return nil
    }
}
