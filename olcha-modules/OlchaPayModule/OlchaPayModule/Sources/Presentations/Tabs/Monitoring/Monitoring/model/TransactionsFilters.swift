//
//  TransactionFilterRequest.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 29/03/23.
//

import Foundation
import OlchaUtils
import OlchaCore
public struct TransactionsFilters {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var from: String?//yyyy-MM-dd
    var to: String?//yyyy-MM-dd
    var cardID: Int?
    var categoryID: Int?
    var cardType: String?
    let paging = Paging()
    
    public init() {
        
    }
    
//    public required init(instance: TransactionsFilter) {
//        self.from = instance.from
//        self.to = instance.to
//        self.cardID = cardID
//    }
    
    public func getFromMinimumDate() -> Date? {
        nil
    }
    
    public func getFromMaximumDate() -> Date? {
        guard let to else { return Date() }
        return dateFormatter.date(from: to)
    }
    
    public func getToMaximumDate() -> Date? {
        return Date()
    }
    
    public func getToMinimumDate() -> Date? {
        guard let from else { return nil }
        return dateFormatter.date(from: from)
    }
}
