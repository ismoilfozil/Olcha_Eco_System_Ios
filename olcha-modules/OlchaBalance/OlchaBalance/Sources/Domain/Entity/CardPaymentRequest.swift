//
//  CardPaymentRequest.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/11/22.
//

import Foundation
public struct CardPaymentRequest: Codable {
    public let card_id: Int
    public let amount: String
}

public struct LinkPaymentData: Codable {
    public var link: String?
    
    public init(link: String?) {
        self.link = link
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.link = try container.decodeIfPresent(String.self, forKey: .link)
        } catch {}
    }
    
    public func getUrl() -> String {
        link ?? ""
    }
}
