//
//  CardPaymentData.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/11/22.
//

import Foundation
public struct CardPaymentData : Codable {
    public var payment_id: Int?
    public var otp: Bool?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.payment_id = try container.decodeIfPresent(Int.self, forKey: .payment_id)
        } catch {}
        
        do {
            self.otp = try container.decodeIfPresent(Bool.self, forKey: .otp)
        } catch {}
    }
    
    public init(payment_id: Int? = nil,
                otp: Bool? = nil)
    {
        self.payment_id = payment_id
        self.otp = otp
    }
}
