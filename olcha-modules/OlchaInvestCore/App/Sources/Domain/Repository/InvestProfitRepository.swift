//
//  InvestProfitRepository.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaCore
import Combine

public protocol InvestProfitRepositoryProtocol {
    func withdrawProfit(model: WithdrawalRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
    func autoWithdrawal(contractId: Int) -> AnyPublisher<BaseResponse<AutoWithdrawalData, EmptyData>, Never>
    func toggleAutoWithdrawalStatus(contractId: Int) -> AnyPublisher<BaseResponse<ToggleAutoWithdrawalResponse, EmptyData>, Never>
    func storeAutoWithdraw(model: AutoWithdrawalRequest) -> AnyPublisher<BaseResponse<AutoWithdrawalData, EmptyData>, Never>
}

public class InvestProfitRepository: BaseRepository, InvestProfitRepositoryProtocol {

    public func withdrawProfit(model: WithdrawalRequest) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        let api: ProfitApi = .withdrawalRequest(withdrawal: model)
        return manager.request(api: api)
    }
    
    public func autoWithdrawal(contractId: Int) -> AnyPublisher<BaseResponse<AutoWithdrawalData, EmptyData>, Never> {
        let api: ProfitApi = .autoWithdrawal(contractId: contractId)
        return manager.request(api: api)
    }
    
    public func toggleAutoWithdrawalStatus(contractId: Int) -> AnyPublisher<BaseResponse<ToggleAutoWithdrawalResponse, EmptyData>, Never> {
        let api: ProfitApi = .toggleAutoWithdrawalStatus(contractId: contractId)
        return manager.request(api: api)
    }
    
    public func storeAutoWithdraw(model: AutoWithdrawalRequest) -> AnyPublisher<OlchaCore.BaseResponse<AutoWithdrawalData, OlchaCore.EmptyData>, Never> {
        let api: ProfitApi = .storeAutoWithdrawal(autoWithdrawal: model)
        return manager.request(api: api)
    }
    
}
