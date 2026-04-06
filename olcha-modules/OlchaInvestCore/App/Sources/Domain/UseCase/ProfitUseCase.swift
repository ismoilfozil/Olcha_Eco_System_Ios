//
//  ProfitUseCase.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 08/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Combine
import OlchaCore

public protocol WithdrawProfitProtocol {
    func execute(model: WithdrawalRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public protocol AutoWithdrawalProfitProtocol {
    func execute(contractId: Int) -> AnyPublisher<BaseResponse<AutoWithdrawalData, EmptyData>, Never>
}

public protocol ToggleAutoWithdrawalStatusProtocol {
    func execute(contractId: Int) -> AnyPublisher<BaseResponse<ToggleAutoWithdrawalResponse, EmptyData>, Never>
}

public protocol StoreAutoWithdrawProtocol {
    func execute(model: AutoWithdrawalRequest) -> AnyPublisher<BaseResponse<AutoWithdrawalData, EmptyData>, Never>
}

public enum ProfitUseCase {
    
    public class WithdrawProfit: WithdrawProfitProtocol {
        
        private let repository: InvestProfitRepositoryProtocol
        
        public init(repository: InvestProfitRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: WithdrawalRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.withdrawProfit(model: model)
        }
        
    }
    
    public class AutoWithdrawalProfit: AutoWithdrawalProfitProtocol {
        
        private let repository: InvestProfitRepositoryProtocol
        
        public init(repository: InvestProfitRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(contractId: Int) -> AnyPublisher<BaseResponse<AutoWithdrawalData, EmptyData>, Never> {
            repository.autoWithdrawal(contractId: contractId)
        }
        
    }
    
    public class ToggleAutoWithdrawalStatus: ToggleAutoWithdrawalStatusProtocol {
        
        private let repository: InvestProfitRepositoryProtocol
        
        public init(repository: InvestProfitRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(contractId: Int) -> AnyPublisher<BaseResponse<ToggleAutoWithdrawalResponse, EmptyData>, Never> {
            repository.toggleAutoWithdrawalStatus(contractId: contractId)
        }
        
    }
    
    public class StoreAutoWithdraw: StoreAutoWithdrawProtocol {
        private let repository: InvestProfitRepositoryProtocol
        
        public init(repository: InvestProfitRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: AutoWithdrawalRequest) -> AnyPublisher<BaseResponse<AutoWithdrawalData, EmptyData>, Never> {
            repository.storeAutoWithdraw(model: model)
        }
    }
    
}
