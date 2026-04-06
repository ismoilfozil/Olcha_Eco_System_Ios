//
//  SavedTransactionModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 31/03/23.
//

import Foundation
import OlchaCore
import OlchaUtils
public struct SavedTransactionsData: Codable {
    var saved_transactions: [SavedTransactionModel]?
    var paginator: Paginator?
}

public struct SavedTransactionData: Codable {
    var saved_transactions: SavedTransactionModel?
}

public struct SavedTransactionModel: Codable {
    var id: Int?
    var name: String?
    var service_price: Double?
    var provider_service: TransactionProviderService?
    var fields: [TransactionKeyValueModel]?
}
