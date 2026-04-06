//
//  BarcodeAPI.swift
//  OlchaPayModule
//
//  Created by Claude Code
//

import Foundation
import OlchaCore
import Alamofire

public enum BarcodeAPI {
    case generate(userId: Int)
}

// Custom header for Barcode API with Basic auth
public class BarcodeAPIHeader: ApiHeader {
    public var items: HTTPHeaders

    public init(items: HTTPHeaders) {
        self.items = items
    }

    static var shared: BarcodeAPIHeader {
        // Basic auth token from Android: YXBpX21lcmNoYW50Ono6UzXCo0t1Q2w3XXo8N0IxaTZLeUI4cWt2SGw=
        let items: HTTPHeaders = [
            "Authorization": "Basic YXBpX21lcmNoYW50Ono6UzXCo0t1Q2w3XXo8N0IxaTZLeUI4cWt2SGw=",
            "Accept-Language": String.getAppLanguage()
        ]
        return BarcodeAPIHeader(items: items)
    }
}

extension BarcodeAPI: BaseAPI {
    public var baseURL: String {
        return "https://merchant.olchanasiya.uz"
    }

    public var version: String {
        return "api"
    }

    public var path: String {
        switch self {
        case .generate:
            return "barcode/generate"
        }
    }

    public var method: RequestType {
        switch self {
        case .generate:
            return .post
        }
    }

    public var body: Data? {
        return nil
    }

    public var headers: ApiHeader {
        return BarcodeAPIHeader.shared
    }

    public var queryItems: [URLQueryItem] {
        switch self {
        case .generate(let userId):
            return [URLQueryItem(name: "user_id", value: "\(userId)")]
        }
    }

    public var params: [String: String] {
        return [:]
    }
}
