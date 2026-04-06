//
//  InvestHomeViewModel.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUI
import Foundation
import OlchaCore

public class InvestHomeViewModel: BaseViewModel {
    
    @Published public var notifications: LoadingState<InvestNotificationData, BaseErrorType> = .standart
    @Published public var invests: LoadingState<InvestorContractData, BaseErrorType> = .standart
    
    private let loadNotificationsUseCase: LoadNotificationsProtocol
    private let loadInvestsUseCase: LoadInvestsProtocol
    private let loadAccountUseCase: LoadAccountProtocol
    
    public init(
        loadNotificationsUseCase: LoadNotificationsProtocol,
        loadInvestsUseCase: LoadInvestsProtocol,
        loadAccountUseCase: LoadAccountProtocol
    ) {
        self.loadNotificationsUseCase = loadNotificationsUseCase
        self.loadInvestsUseCase = loadInvestsUseCase
        self.loadAccountUseCase = loadAccountUseCase
    }
    
    func loadNotifications(page: Int) {
        notifications = .loading
        loadNotificationsUseCase.execute(page: page)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    notifications = .success(baseResponse.response)
                default:
                    notifications = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
    func loadInvests(page: Int) {
        guard invests != .loading else { return }
        invests = .loading
        loadInvestsUseCase.execute(page: page)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    invests = .success(baseResponse.response)
                default:
                    invests = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
    func loadAccount() {
        loadAccountUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    InvestGlobalDefaults.account.investorId = baseResponse.response?.investor.id
                default:
                    break
                }
            }.store(in: &bag)
    }
    
}
