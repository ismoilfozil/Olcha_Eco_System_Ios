//
//  BaseBalanceViewModel.swift
//  OlchaBalance
//
//  Created by Elbek Khasanov on 10/07/23.
//

import Foundation
import Combine
import OlchaAuth
import OlchaUI
import OlchaCore
import OlchaBankCards
import OlchaUtils

open class BalanceViewModel: BaseViewModel {
    
    @Published public var payments: LoadingState<[Payments], BaseErrorType> = .standart
    @Published public var paymentTransaction: LoadingState<CardPaymentData, BaseErrorType> = .standart
    @Published public var paymentTransactionFinished: LoadingState<CardPaymentData, BaseErrorType> = .standart
    @Published public var paymentRedirectURL: LoadingState<String, BaseErrorType> = .standart
    @Published public var balance: LoadingState<BalancesData, BaseErrorType> = .standart
    
    private let loadBalanceUseCase: LoadBalanceProtocol
    private let loadPaymentTypesUseCase: LoadPaymentTypesProtocol
    private let makePaymentTransactionUseCase: MakePaymentTransactionProtocol
    private let makePaymentTransactionOTPUseCase: MakePaymentTransactionOTPProtocol
    private let generateLinkUseCase: GenerateLinkProtocol
    
    public init(loadBalanceUseCase: LoadBalanceProtocol,
                loadPaymentTypesUseCase: LoadPaymentTypesProtocol,
                makePaymentTransactionUseCase: MakePaymentTransactionProtocol,
                makePaymentTransactionOTPUseCase: MakePaymentTransactionOTPProtocol,
                generateLinkUseCase: GenerateLinkProtocol) {
        self.loadBalanceUseCase = loadBalanceUseCase
        self.loadPaymentTypesUseCase = loadPaymentTypesUseCase
        self.makePaymentTransactionUseCase = makePaymentTransactionUseCase
        self.makePaymentTransactionOTPUseCase = makePaymentTransactionOTPUseCase
        self.generateLinkUseCase = generateLinkUseCase
    }
    
    open func loadBalance() {
        guard AuthGlobalDefaults.isUser() else { return }
        self.balance = .loading
        loadBalanceUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    print("check balanceeee", baseResponse.response?.instalmentBalance)
                    self.balance = .success(baseResponse.response)
                default:
                    self.balance = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
#warning("reflection removed")
    open func loadPaymentTypes() {
        self.payments = .loading
        
        loadPaymentTypesUseCase.execute(
//            filter: .init(settings: .init(reflection: .balance))
            filter: .init()
        )
        .sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                self.payments = .success(baseResponse.response?.payments ?? [])
            default:
                self.payments = .failure(.init(message: baseResponse.error))
            }
        }.store(in: &bag)
    }
    #warning("reflection removed")
    open func getSecureCodePayment(card: BankCard?, amount: String?) {

        guard let id = card?.cardId,
              let amount = amount,
              amount != "" else { return }
        
        let model = CardPaymentRequest(card_id: id,
                                       amount: amount)
        
        self.paymentTransaction = .loading
        
        makePaymentTransactionUseCase.execute(
            model: model,
//            filter: .init(settings: .init(reflection: .balance))
            filter: .init()
        )
        .sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                self.paymentTransaction = .success(baseResponse.response)
            default:
                self.paymentTransaction = .failure(baseResponse.validationErrors)
            }
        }.store(in: &bag)
    }
#warning("reflection removed")
    open func providePaymentOTP(otp: String) {
        guard let transactionID = paymentTransaction.value?.payment_id else { return }
        
        let model = ProvideOTPPaymentRequest(transaction: transactionID, otp: otp)
        
        self.paymentTransactionFinished = .loading
        
        makePaymentTransactionOTPUseCase.execute(
            model: model,
            filter: .init(
//                settings: .init(reflection: .balance)
            )
        )
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.paymentTransactionFinished = .success(baseResponse.response)
                default:
                    self.paymentTransactionFinished = .failure(baseResponse.validationErrors)
                }
            }.store(in: &bag)
    }
#warning("reflection removed")
    open func enterPayment(amount: String, payment: Payments?) {
        guard let alias = payment?.alias else { return }
        
        generateLinkUseCase.execute(
            model: .init(alias: alias, amount: amount),
            filter: .init(
//                settings: .init(reflection: .balance)
            )
        )
        .sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
                case .success:
                    paymentRedirectURL = .success(baseResponse.response?.getUrl())
                default:
                    paymentRedirectURL = .failure(baseResponse.validationErrors)
                }
            }.store(in: &bag)
        
    }
}
