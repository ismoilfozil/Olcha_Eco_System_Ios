//
//  BillingPaymentData.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 06/07/23.
//

import Foundation

public struct BillingPaymentData: Codable {
    
    public var otp: Bool?
    public var link: String?
    public var transaction_id: Int?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.otp = try container.decodeIfPresent(Bool.self, forKey: .otp)
        } catch {}
        do {
            self.link = try container.decodeIfPresent(String.self, forKey: .link)
        } catch {}
        do {
            self.transaction_id = try container.decodeIfPresent(Int.self, forKey: .transaction_id)
        } catch {}
    }
    
    public init(otp: Bool? = nil, link: String? = nil, transaction_id: Int? = nil) {
        self.otp = otp
        self.link = link
        self.transaction_id = transaction_id
    }
    
    public func withOtp() -> Bool {
        otp ?? false
    }
    
    public func getUrl() -> String {
        link ?? ""
    }
}
