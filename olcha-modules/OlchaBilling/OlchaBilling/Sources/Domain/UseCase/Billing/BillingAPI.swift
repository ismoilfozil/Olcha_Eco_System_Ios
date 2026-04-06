//
//  BillingAPI.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 21/06/23.
//

import Foundation
import Combine
import OlchaCore
import OlchaUtils
import SwiftyJSON
import OlchaUtils
import OlchaBankCards

public protocol BillingAPIProtocol: BankCardAPIProtocol {
    func payments(filter: BillingPaymentFilter) -> BaseAPI
    func generateLink(filter: BillingPaymentFilter) -> BaseAPI
    func makePayment(filter: BillingPaymentFilter) -> BaseAPI
    func makePaymentOtp(filter: BillingPaymentFilter) -> BaseAPI
    func loadEntities(filter: BillingPaymentFilter) -> BaseAPI
    func loadCurrency(filter: BillingPaymentFilter) -> BaseAPI
}

open class BillingAPI: BillingAPIProtocol {
    
    public func payments(filter: BillingPaymentFilter) -> BaseAPI {
        let api = BaseBillingApi(
            path: "available-systems",
            method: .get,
            queryItems: [
                .init(name: "billing_reflection_alias",
                      value: filter.getReflection())
            ],
            headers: BillingHeader.headers()
        )
        return api
    }
    
    public func generateLink(filter: BillingPaymentFilter) -> BaseAPI {
        let api = BaseBillingApi(
            path: "generate-link",
            method: .post,
            headers: BillingHeader.headers()
        )
        api.body = api.encode(
            GenerateLinkRequest(entity_id: filter.getEntityID(),
                                amount: filter.amount?.string,
                                payment_system_alias: filter.getPaymentAlias(),
                                billing_reflection_alias: filter.getReflection())
        )
        return api
    }
 
    public func makePayment(filter: BillingPaymentFilter) -> BaseAPI {
        let api = BaseBillingApi(
            path: "api-payments/confirm-payment",
            method: .post,
            headers: BillingHeader.headers()
        )
        
        api.body = api.encode(
            BillingOtpPaymentRequest(transaction_id: filter.transaction_id?.int,
                                     otp: filter.otp,
                                     payment_system_alias: filter.getPaymentAlias(),
                                     billing_reflection_alias: filter.getReflection())
        )
        return api
    }
    
    public func makePaymentOtp(filter: BillingPaymentFilter) -> BaseAPI {
        let api = BaseBillingApi(
            path: "api-payments/payment",
            method: .post,
            headers: BillingHeader.headers()
        )
        api.body = api.encode(
            BillingConfirmationRequest(payment_entity_id: filter.getPaymentEntityID()?.string,
                                       entity_id: filter.getEntityID()?.string,
                                       amount: filter.amount?.string,
                                       payment_system_alias: filter.getPaymentAlias(),
                                       billing_reflection_alias: filter.getReflection())
        )
        return api
    }
    
    public func loadEntities(filter: BillingPaymentFilter) -> BaseAPI {
        let api = BaseBillingApi(
            path: "api-payments/entity-collection",
            method: .get,
            queryItems: [
                .init(name: "billing_reflection_alias", value: filter.getReflection()),
                .init(name: "collection_type", value: filter.settings.collectionType.rawValue),
            ],
            headers: BillingHeader.headers())
        return api
    }
    
    public func loadCurrency(filter: BillingPaymentFilter) -> BaseAPI {
        let api = BaseBillingApi(path: "currency-rate",
                                 method: .get,
                                 queryItems: [
                                    .init(name: "billing_reflection_alias", value: filter.getReflection()),
                                    .init(name: "entity_id", value: filter.getEntityID()?.string),
                                    .init(name: "entity_currency", value: filter.getOrderCurrency()),
                                    .init(name: "payment_system_currency", value: filter.getPaymentCurrency()),
                                 ],
                                 headers: BillingHeader.headers())
        return api
    }
    
}
