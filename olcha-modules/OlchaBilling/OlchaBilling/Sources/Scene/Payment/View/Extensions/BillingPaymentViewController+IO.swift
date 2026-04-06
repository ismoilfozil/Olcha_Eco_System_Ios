//
//  BillingPaymentViewController+IO.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 21/06/23.
//

import OlchaBankCards
import OlchaUtils
import Combine
import Foundation
import OlchaUI

extension BillingPaymentViewController {
    public class Input {
        public let webhooksSkeleton = Skeleton(count: 3)
        public let bankCardsSkeleton = Skeleton(count: 2)
        public let balancesSkeleton = Skeleton(count: 3)
        
        public var billingFilter = BillingPaymentFilter()
        
        public var paymentTypes: BillingPaymentsData? {
            didSet {
                webhooks = paymentTypes?.getWebhooks() ?? []
            }
        }
        
        public var webhooks: [BillingPayment] = []
        public var bankCardParents: [BillingCollectionItem] = []
        public var balances: [BillingCollectionItem] = []
        
        public var currency: BillingCurrencyData?
        
        public init() {}
        
        public func select(_ webhook: BillingPayment) {
            billingFilter.payment.paymentState = .webhook
            billingFilter.set(payment_currency: webhook.currency)
            billingFilter.payment.setIdentifier(alias: webhook.alias, id: nil)
            billingFilter.payment.set(min_value: webhook.min_amount,
                                      max_value: webhook.max_amount)
            billingFilter.payment.setCurrentAmount()
        }
        
        public func select(_ parent: BillingCollectionItem, _ bankCard: BillingBankCard) {
            billingFilter.payment.paymentState = .bankCard
            billingFilter.set(payment_currency: parent.currency)
            billingFilter.payment.setIdentifier(alias: parent.alias,
                                                        id: bankCard.id?.int)
            billingFilter.payment.set(min_value: parent.min_amount,
                                      max_value: parent.max_amount)
            billingFilter.payment.setCurrentAmount(value: bankCard.getAmount())
        }
        
        public func select(_ balance: BillingCollectionItem) {
            billingFilter.payment.paymentState = .balance
            billingFilter.set(payment_currency: balance.currency)
            billingFilter.payment.setIdentifier(alias: balance.alias,
                                                id: balance.balance?.id?.int)
            billingFilter.payment.set(min_value: balance.min_amount,
                                      max_value: balance.max_amount)
            billingFilter.payment.setCurrentAmount(value: balance.balance?.amount)
        }
    }
    
    public class Output {
        public let addCardObserver = PassthroughSubject<BillingCollectionItem, Never>()
        public let loadCards = PassthroughSubject<Bool, Never>()
        
        public init() {}
    }
}
