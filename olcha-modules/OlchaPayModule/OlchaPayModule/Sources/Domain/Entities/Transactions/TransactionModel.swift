//
//  TransactionModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/03/23.
//

import Foundation
import OlchaCore
import OlchaUtils
import UIKit

public struct TransactionsData: Codable {
    var id: Int?
    var total: Double?
    var transactions: [TransactionModel]?
    var paginator: Paginator?
}

public struct TransactionData: Codable {
    var id: Int?
    var transaction: TransactionModel?
}

public struct TransactionOtpData: Codable {
    var transaction: TransactionOtpModel?
    var transactions: TransactionModel?
    
    func getSession() -> Int? {
        transaction?.session
    }
    
    func getTransactionId() -> Int? {
        transaction?.transaction_id
    }
    
    func getPhone() -> String {
        (transaction?.otpSentPhone ?? "").formatPhoneNumberCharacter
    }
}

public struct TransactionOtpModel: Codable {
    var transaction_id: Int?
    var session: Int?
    var otpSentPhone: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.transaction_id = try container.decodeIfPresent(Int.self, forKey: .transaction_id)
        } catch {}
        do {
            self.session = try container.decodeIfPresent(Int.self, forKey: .session)
        } catch {}
        do {
            self.otpSentPhone = try container.decodeIfPresent(String.self, forKey: .otpSentPhone)
        } catch {}
    }
}


public struct TransactionModel: Codable {
    var id: Int?
    var amount: Double?
    var status: String?
    var status_name: String?
    var status_colour: String?
    var created_at: String?
    var transaction_in: [TransactionInModel]?
    var transaction_out: [TransactionOutModel]?
    var card_id: UserBankCardModel?
    var fields: [TransactionKeyValueModel]?
    var provider_service: TransactionProviderService?
    
//    init(id: Int? = nil, amount: Double? = nil, status: String? = nil, status_name: String? = nil, status_colour: String? = nil, created_at: String? = nil, transaction_in: [TransactionInModel]? = nil, transaction_out: [TransactionOutModel]? = nil, card_id: UserBankCardModel? = nil, fields: [TransactionKeyValueModel]? = nil, provider_service: TransactionProviderService? = nil) {
//        self.id = id
//        self.amount = amount
//        self.status = status
//        self.status_name = status_name
//        self.status_colour = status_colour
//        self.created_at = created_at
//        self.transaction_in = transaction_in
//        self.transaction_out = transaction_out
//        self.card_id = card_id
//        self.fields = fields
//        self.provider_service = provider_service
//    }

    static func mock() -> TransactionModel {
        let model = TransactionModel(id: 63, amount: 1000, status: "commited", created_at: "2023-04-07T09:28:42.849095+05:00", transaction_in: [], transaction_out: [.init(id: 63, type: "paynet", status: "commited", provider_service: nil)], card_id: .mock(), fields: [], provider_service: .mock())

        return model
    }
    
    func date() -> String {
        created_at?.formated_date ?? " - "
    }
    
    func dateTime() -> String {
        created_at?.formated_date_time ?? " - "
    }
    
    func getStatus() -> String? {
        (status_name ?? status)
    }
    
    func getColor() -> UIColor? {
        if let status_colour {
            return UIColor.hex(status_colour)
        } else {
            return .olchaLightTextColornnnnnn
        }
    }
}

public struct TransactionInModel: Codable {
    var id: Int?
    var type: String?
    var status: String?
    var data: TransactionInData?
    
}

public struct TransactionOutModel: Codable {
    var id: Int?
    var type: String?
    var status: String?
    var provider_service: Int?
   
    func getStatus() -> TransactionStatus {
        guard let status = TransactionStatus(rawValue: status ?? "") else {
            return .none
        }
        return status
    }
}

public struct TransactionInData: Codable {
    var date: String?
                                
    var amount: Double?
    var cardId: Int?
    
    var cardNumber: String?
    var statusComment: String?
    var transactionId: Int?

}

public struct TransactionProviderService: Codable {
    var id: Int?
    var providers: ProviderModel?
    var service_price: Double?
    var transaction: Int?
    
    static func mock() -> TransactionProviderService {
        return TransactionProviderService(id: 12, providers: .init(id: 5, title: "ООО UNIVERSAL MOBILE SYSTEMS", title_short: "UMS", category_id: 1, logo: .init(logo: "/media/logo/provider_agent_id_2915.png", provider: 5), service: nil), service_price: nil, transaction: nil)
    }
    
    func getServicePrice() -> String {
        service_price?.string ?? "0"
    }
}

public enum TransactionStatus: String {
    case commited
    case canceled
    case reversed
    case pending
    case none
    
    var title: String {
        switch self {
        case .none:
            return " - "
        default:
            return self.rawValue.localized()
        }
    }
}
