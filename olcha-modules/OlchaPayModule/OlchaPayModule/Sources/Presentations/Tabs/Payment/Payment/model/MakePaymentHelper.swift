//
//  PaymentHelper.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 11/04/23.
//

import Foundation
import OlchaUtils
import Combine
import OlchaUI

public class MakePaymentHelper {
    var observers = Observers()
    
    public struct Observers {
        let selectedCard = PassthroughSubject<Bool, Never>()
        let providerUpdated = PassthroughSubject<Bool, Never>()
        let serviceUpdated = PassthroughSubject<Bool, Never>()
    }
    
    var serviceID: Int?
    var providerID: Int?
    
    var provider: ProviderModel? {
        didSet {
            providerID = provider?.id
            observers.providerUpdated.send(true)
        }
    }
    
    var service: ServiceModel? {
        didSet {
            serviceID = service?.id
            observers.serviceUpdated.send(true)
        }
    }
    
    var fields: [TransactionKeyValueModel] = []
    var filledFields: [TransactionKeyValueModel] = []
    
    var selectedCard: UserBankCardModel?
    
    public func configure(savedTransaction: SavedTransactionModel?) {
        providerID = savedTransaction?.provider_service?.providers?.id
        serviceID = savedTransaction?.provider_service?.id
        
        filledFields = savedTransaction?.fields ?? []
    }
    
    public func configure(transaction: TransactionModel?) {
        providerID = transaction?.provider_service?.providers?.id
        serviceID = transaction?.provider_service?.id
        
        filledFields = transaction?.fields ?? []
    }
    
    public func getFilledValue(key: String?) -> String? {
        guard let key = key else { return nil }
        return filledFields.first {
            return $0.key == key
        }?.value
    }
    
    public func addService(_ service: ServiceModel?) -> Self {
        self.service = service
        return self
    }
    
    public func addProvider(_ provider: ProviderModel?) -> Self {
        self.provider = provider
        return self
    }
    
    public func addService(_ id: Int?) -> Self {
        self.serviceID = id
        return self
    }
    
    public func addProvider(_ id: Int?) -> Self {
        self.providerID = id
        return self
    }
    
    public func addFilledFields(_ filledFields: [TransactionKeyValueModel]?) -> Self {
        self.filledFields = filledFields ?? []
        return self
    }
    
    public func resetProvider() {
        provider = nil
    }
    
    public func getSelectedCardAmount() -> Double {
        selectedCard?.bank_card?.balance ?? 0
    }
}

