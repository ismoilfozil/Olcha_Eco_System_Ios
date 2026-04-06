//
//  BillingViewModel.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 21/06/23.
//

import UIKit
import OlchaUI
import OlchaCore
import OlchaUtils
import OlchaBankCards


public class BillingViewModel: BaseViewModel {
    
    @Published public var balances: LoadingState<BillingEntitiesData, BaseErrorType> = .standart
    @Published public var bankCards: LoadingState<BillingEntitiesData, BaseErrorType> = .standart
    @Published public var paymentTypes: LoadingState<BillingPaymentsData, BaseErrorType> = .standart
    @Published public var webhookPayment: LoadingState<BillingPaymentData, BaseErrorType> = .standart
    @Published public var otpPayment: LoadingState<BillingPaymentData, BaseErrorType> = .standart
    @Published public var bankCardPayment: LoadingState<EmptyData, BaseErrorType> = .standart
    @Published public var currency: LoadingState<BillingCurrencyData, BaseErrorType> = .standart
    
    @Published public var fieldErrorMessage: String?
    
    private let generatePaymentLinkUseCase: GeneratePaymentLinkProtocol
    private let loadPaymentTypesUseCase: LoadPaymentTypesProtocol
    private let makePaymentOtpUseCase: MakePaymentOtpProtocol
    private let loadBillingEntitiesUseCase: LoadBillingEntitiesProtocol
    private let makePaymentUseCase: MakePaymentProtocol
    private let loadCurrencyUseCase: LoadBillingCurrencyProtocol
    
    public init(loadPaymentTypesUseCase: LoadPaymentTypesProtocol,
                makePaymentOtpUseCase: MakePaymentOtpProtocol,
                makePaymentUseCase: MakePaymentProtocol,
                generatePaymentLinkUseCase: GeneratePaymentLinkProtocol,
                loadBillingEntitiesUseCase: LoadBillingEntitiesProtocol,
                loadCurrencyUseCase: LoadBillingCurrencyProtocol) {
        self.loadPaymentTypesUseCase = loadPaymentTypesUseCase
        self.makePaymentOtpUseCase = makePaymentOtpUseCase
        self.makePaymentUseCase = makePaymentUseCase
        self.generatePaymentLinkUseCase = generatePaymentLinkUseCase
        self.loadBillingEntitiesUseCase = loadBillingEntitiesUseCase
        self.loadCurrencyUseCase = loadCurrencyUseCase
    }
    
    public func loadPaymentTypes(filter: BillingPaymentFilter, completion: ((BillingPaymentsData?) -> Void)? = nil) {
        
        paymentTypes = .loading
        loadPaymentTypesUseCase.execute(filter: filter).sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                paymentTypes = .success(baseResponse.response)
            default:
                paymentTypes = .failure(baseResponse.validationErrors)
            }
        }.store(in: &bag)
    }

    public func payWebhook(filter: BillingPaymentFilter) {
        webhookPayment = .loading
        generatePaymentLinkUseCase.execute(filter: filter)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    webhookPayment = .success(baseResponse.response)
                default:
                    fieldErrorMessage = baseResponse.error
                    webhookPayment = .failure(baseResponse.validationErrors)
                }
            }.store(in: &bag)
    }
    
    public func sendOtp(filter: BillingPaymentFilter) {
        otpPayment = .loading
        makePaymentOtpUseCase.execute(filter: filter)
            .sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                otpPayment = .success(baseResponse.response)
            default:
                otpPayment = .failure(baseResponse.validationErrors)
            }
        }.store(in: &bag)
    }
    
    public func payBankCard(filter: BillingPaymentFilter) {
        bankCardPayment = .loading
        
        makePaymentUseCase.execute(filter: filter)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    bankCardPayment = .success(baseResponse.response)
                default:
                    bankCardPayment = .failure(baseResponse.validationErrors)
                }
            }.store(in: &bag)
    }
    
    /// reflection_alias is unique for all apps, invest, nasiya and etc.
    public func loadAllBalances(reflection_alias: String) {
        balances = .loading
        let filter = BillingPaymentFilter()
            .set(reflection: reflection_alias)
            .set(collectionType: .balance)
        loadBillingEntitiesUseCase.execute(
            filter: filter
        )
        .sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                balances = .success(baseResponse.response)
            default:
                balances = .failure(baseResponse.validationErrors)
            }
        }.store(in: &bag)
        
    }
    
    public func loadBalances(
        filter: BillingPaymentFilter = .init()
    ) {
        balances = .loading
        loadBillingEntitiesUseCase.execute(filter: filter.set(collectionType: .balance))
            .sink { [weak self] baseResponse in
                guard let self = self else { return }

                switch baseResponse.status {
                case .success:
                    balances = .success(baseResponse.response)
                default:
                    balances = .failure(baseResponse.validationErrors)
                }
                
            }.store(in: &bag)
        
    }
    
    public func loadBankCards(filter: BillingPaymentFilter = .init()) {
        bankCards = .loading
        loadBillingEntitiesUseCase.execute(filter: filter.set(collectionType: .bank_card))
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    bankCards = .success(baseResponse.response)
                default:
                    bankCards = .failure(baseResponse.validationErrors)
                }
            }.store(in: &bag)
        
    }
    
    public func loadCurrency(filter: BillingPaymentFilter = .init()) {
        guard !filter.isCurrencyEqual else { return }
        currency = .loading
        loadCurrencyUseCase.execute(filter: filter)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    currency = .success(baseResponse.response)
                case .fail:
                    currency = .failure(baseResponse.validationErrors)
                default:
                    break
                }
            }.store(in: &bag)
    }
}
