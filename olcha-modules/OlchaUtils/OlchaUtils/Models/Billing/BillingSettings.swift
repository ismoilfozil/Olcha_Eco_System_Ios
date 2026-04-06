//
//  BillingSettings.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 10/08/23.
//

import Foundation

public typealias Reflection = String

public class BillingSettings {
    ///
    /// Reflection it is default, when loading all balances. But when we pay for order, balance, invest and etc.
    ///
    public var reflection: Reflection = ""
    ///
    /// Collection_type is enum, which has: balance, bank_cards
    ///
    public var collectionType: BillingCollectionType = .balance
    
    public init(reflection: Reflection? = "",
                collectionType: BillingCollectionType = .balance) {
        self.reflection = reflection ?? ""
        self.collectionType = collectionType
    }
    
    @discardableResult
    public func set(reflection: Reflection?) -> Self {
        self.reflection = reflection ?? ""
        return self
    }
    
    @discardableResult
    public func set(collectionType: BillingCollectionType) -> Self {
        self.collectionType = collectionType
        return self
    }
}
