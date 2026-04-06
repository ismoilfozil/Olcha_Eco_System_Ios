//
//  BalansAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/11/22.
//

import Foundation
import OlchaCore
import OlchaUtils

public protocol BalanceAPIProtocol {
    func balance() -> BaseAPI
    func paymentTypes() -> BaseAPI
    func cardFill(model: CardPaymentRequest) -> BaseAPI
    func provideCardPayment(model: ProvideOTPPaymentRequest) -> BaseAPI
    func paymentFill(model: FillPaymentRequest) -> BaseAPI
    func generateLink() -> BaseAPI
}

public class BalanceAPI: BalanceAPIProtocol {
    public func balance() -> OlchaCore.BaseAPI {
        let api = OlchaBalanceAPI(path: "balances",
                                  version: Texts.url.getVersion(3),
                                  method: .get)
        return api
    }
    
    public func paymentTypes() -> OlchaCore.BaseAPI {
        let api = OlchaBalanceAPI(path: "payments",
                                  method: .get)
        return api
    }
    
    public func cardFill(model: CardPaymentRequest) -> OlchaCore.BaseAPI {
        let api = OlchaBalanceAPI(path: "balances/replenish",
                                  method: .post,
                                  body: model)
        return api
    }
    
    public func provideCardPayment(model: ProvideOTPPaymentRequest) -> OlchaCore.BaseAPI {
        let api = OlchaBalanceAPI(path: "balances/confirm-payment",
                                  method: .post,
                                  body: model)
        return api
    }
    
    public func paymentFill(model: FillPaymentRequest) -> OlchaCore.BaseAPI {
        let api = OlchaBalanceAPI(path: "",
                                  version: Texts.url.getVersion(2),
                                  method: .post,
                                  body: model)
        return api
    }
    
    public func generateLink() -> BaseAPI {
        let api = OlchaBalanceAPI(path: "", method: .get)
        return api
    }
}
