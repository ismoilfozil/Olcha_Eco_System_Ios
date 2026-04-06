//
//  BillingPayment.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 23/06/23.
//

import Foundation
import OlchaUtils

public class BillingPaymentsData: Codable {
    
    public var payment_systems: [BillingPayment]?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            payment_systems = try container.decodeIfPresent([BillingPayment].self, forKey: .payment_systems)
        } catch {}
    }
    
    
    public func getWebhooks() -> [BillingPayment] {
        payment_systems ?? []
    }
    
    
}

public struct BillingPayment: Codable {
    public var max_amount: Int?
    public var provider_name: String?
    public var alias: String?
    public var logo: String?
    public var min_amount: Int?
    public var provider_type: String?
    public var name: String?
    public var provider_gateway_type: String?
    public var currency: String?
    
    public enum PaymentType {
        case webhook
        case balance
        case none
    }
    
    public func map() -> Payments {
        let payment = Payments()
        payment.alias = alias
        payment.logo = logo
        payment.min_amount = min_amount
        payment.max_amount = max_amount
        return payment
    }
}

extension String {
    public static let webhook = "webhook"
    public static let api = "api"
    public static let balance_alias = "olcha_nasiya_balance"
}
