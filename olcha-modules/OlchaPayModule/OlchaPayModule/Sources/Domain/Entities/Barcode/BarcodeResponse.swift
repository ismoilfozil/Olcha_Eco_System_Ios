//
//  BarcodeResponse.swift
//  OlchaPayModule
//
//  Created by Claude Code
//

import Foundation

public struct BarcodeResponse: Codable {
    public let code: String?
    public let message: String?

    enum CodingKeys: String, CodingKey {
        case code
        case message
    }

    public init(code: String?, message: String?) {
        self.code = code
        self.message = message
    }
}
