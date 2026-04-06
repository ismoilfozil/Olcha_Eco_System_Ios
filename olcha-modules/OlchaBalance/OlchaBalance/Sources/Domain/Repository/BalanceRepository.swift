//
//  BalanceRepository.swift
//  OlchaBalance
//
//  Created by Elbek Khasanov on 06/07/23.
//

import Foundation
import OlchaCore
import Combine
import OlchaUtils
public protocol BalanceRepositoryProtocol {
    func loadBalance() -> AnyPublisher<BaseResponse<BalancesData, EmptyData>, Never>
    func loadPaymentTypes() -> AnyPublisher<BaseResponse<PaymentTypeData, EmptyData>, Never>
    func makePaymentTransaction(model: CardPaymentRequest) -> AnyPublisher<BaseResponse<CardPaymentData, ValidationErrors>, Never>
    func makePaymentTransactionOtp(model: ProvideOTPPaymentRequest) -> AnyPublisher<BaseResponse<CardPaymentData, ValidationErrors>, Never>
    func generateLink() -> AnyPublisher<BaseResponse<LinkPaymentData, ValidationErrors>, Never>
}

public class BalanceRepository: BaseRepository, BalanceRepositoryProtocol {
    
    private let api: BalanceAPIProtocol
    public init(manager: NetworkManagerProtocol, api: BalanceAPIProtocol) {
        self.api = api
        super.init(manager: manager)
    }
    
    public func loadBalance() -> AnyPublisher<OlchaCore.BaseResponse<BalancesData, OlchaCore.EmptyData>, Never> {
        manager.request(api: api.balance())
    }
    
    public func loadPaymentTypes() -> AnyPublisher<OlchaCore.BaseResponse<OlchaUtils.PaymentTypeData, OlchaCore.EmptyData>, Never> {
        manager.request(api: api.paymentTypes())
    }
    
    public func makePaymentTransaction(model: CardPaymentRequest) -> AnyPublisher<OlchaCore.BaseResponse<CardPaymentData, ValidationErrors>, Never> {
        manager.request(api: api.cardFill(model: model))
    }
    
    public func makePaymentTransactionOtp(model: ProvideOTPPaymentRequest) -> AnyPublisher<OlchaCore.BaseResponse<CardPaymentData, ValidationErrors>, Never> {
        manager.request(api: api.provideCardPayment(model: model))
    }
    
    public func generateLink() -> AnyPublisher<BaseResponse<LinkPaymentData, ValidationErrors>, Never> {
        manager.request(api: api.generateLink())
    }
}
