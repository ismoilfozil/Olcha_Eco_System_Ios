//
//  InvestCardViewModel.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaUI
import OlchaCore

public class InvestCardViewModel: BaseViewModel {
    
    @Published public var isCardSelected: Bool = false
    @Published public var cards: LoadingState<CardData, BaseErrorType> = .standart
    @Published public var hasSentCode: LoadingState<(Bool, String?), BaseErrorType> = .standart
    @Published public var isCardExists: Bool = false
    @Published public var hasConfirmedCode: LoadingState<Bool, BaseErrorType> = .standart
    @Published public var hasWithdrawn: LoadingState<Bool, BaseErrorType> = .standart
    @Published public var hasContractCreated: LoadingState<Bool, BaseErrorType> = .standart
    @Published public var autowithdrawal: LoadingState<AutoWithdrawalModel, BaseErrorType> = .standart
    @Published public var hasStoredAutoWithdrawal: LoadingState<Bool, BaseErrorType> = .standart
    
    private let loadCardsUseCase: LoadCardsProtocol
    private let cardSendOtpUseCase: CardSendOtpProtocol
    private let cardConfirmOtpUseCase: CardConfirmOtpProtocol
    private let withdrawProfitUseCase: WithdrawProfitProtocol
    private let autoWithdrawUseCase: AutoWithdrawalProfitProtocol
    private let storeContractUseCase: StoreContractProtocol
    private let storeAutoWithdrawUseCase: StoreAutoWithdrawProtocol
    
    public init(
        loadCardsUseCase: LoadCardsProtocol,
        cardSendOtpUseCase: CardSendOtpProtocol,
        cardConfirmOtpUseCase: CardConfirmOtpProtocol,
        withdrawProfitUseCase: WithdrawProfitProtocol,
        autoWithdrawUseCase: AutoWithdrawalProfitProtocol,
        storeContractUseCase: StoreContractProtocol,
        storeAutoWithdrawUseCase: StoreAutoWithdrawProtocol
    ) {
        self.loadCardsUseCase = loadCardsUseCase
        self.cardSendOtpUseCase = cardSendOtpUseCase
        self.cardConfirmOtpUseCase = cardConfirmOtpUseCase
        self.withdrawProfitUseCase = withdrawProfitUseCase
        self.autoWithdrawUseCase = autoWithdrawUseCase
        self.storeContractUseCase = storeContractUseCase
        self.storeAutoWithdrawUseCase = storeAutoWithdrawUseCase
    }
    
    func loadCards() {
        guard cards != .loading else { return }
        cards = .loading
        loadCardsUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    cards = .success(baseResponse.response)
                default:
                    cards = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
    func sendOtp(model: CardSendOtpRequest) {
        guard hasSentCode != .loading else { return }
        hasSentCode = .loading
        isCardExists = false
        let request = CardSendOtpRequest(pan: model.pan, expiry: model.expiry.cardCorrection, phone: model.phone)
        cardSendOtpUseCase.execute(model: request)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                if let isCardExists = baseResponse.response?.is_card_exists {
                    self.isCardExists = isCardExists
                }
                switch baseResponse.status {
                case .success:
                    hasSentCode = .success((true, nil))
                case .fail, .canceled:
                    hasSentCode = .success((false, baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    func confirmOtp(model: CardConfirmOtpRequest) {
        hasConfirmedCode = .loading
        let request = CardConfirmOtpRequest(pan: model.pan, expiry: model.expiry.cardCorrection, phone: model.phone, code: model.code)
        cardConfirmOtpUseCase.execute(model: request)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    hasConfirmedCode = .success(true)
                case .fail, .canceled:
                    hasConfirmedCode = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    func withdrawProfit(model: WithdrawalRequest) {
        guard hasWithdrawn != .loading else { return }
        hasWithdrawn = .loading
        withdrawProfitUseCase.execute(model: model)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    hasWithdrawn = .success(true)
                default:
                    hasWithdrawn = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
    func autoWithdrawal(contractId: Int) {
        guard autowithdrawal != .loading else { return }
        autowithdrawal = .loading
        autoWithdrawUseCase.execute(contractId: contractId)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    autowithdrawal = .success(baseResponse.response?.autoWithdrawal)
                default:
                    autowithdrawal = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
    func storeAutoWithdraw(contractId: Int, bankCard: (id: Int, alias: String), percentage: Int) {
        guard autowithdrawal != .loading else { return }
        autowithdrawal = .loading
        hasStoredAutoWithdrawal = .loading
        let request = AutoWithdrawalRequest(
            contract_id: contractId,
            bank_card_id: bankCard.id,
            bank_card_alias: bankCard.alias,
            percentage: percentage
        )
        storeAutoWithdrawUseCase.execute(model: request)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    hasStoredAutoWithdrawal = .success(true)
                    autowithdrawal = .success(baseResponse.response?.autoWithdrawal)
                default:
                    hasStoredAutoWithdrawal = .success(false)
                    autowithdrawal = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
    func storeContract(model: AddContractRequest) {
        guard hasContractCreated != .loading else { return }
        hasContractCreated = .loading
        storeContractUseCase.execute(model: model)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    hasContractCreated = .success(true)
                default:
                    hasContractCreated = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
}
