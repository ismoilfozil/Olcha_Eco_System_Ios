//
//  InvestHomeRepository.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 17/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaCore
import Combine

public protocol InvestHomeRepositoryProtocol {
    func loadNotifications(page: Int) -> AnyPublisher<BaseResponse<InvestNotificationData, EmptyData>, Never>
    func loadInvests(page: Int) -> AnyPublisher<BaseResponse<InvestorContractData, EmptyData>, Never>
    func loadInvestorAccount() -> AnyPublisher<BaseResponse<InvestorAccountData, EmptyData>, Never>
    func storeContract(model: AddContractRequest) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never>
    func loadContract(id: Int) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never>
    func loadContractHistory(id: Int) -> AnyPublisher<BaseResponse<ContractHistoryData, EmptyData>, Never>
    func laodContractChart(id: Int) -> AnyPublisher<BaseResponse<ContractChartData, EmptyData>, Never>
    func toggleContractStatus(id: Int, model: ToggleContractStatusRequest) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never>
    func deleteContract(id: Int) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never>
    func loadWithdrawHistory(id: Int) -> AnyPublisher<BaseResponse<InvestProfitHistoryData, EmptyData>, Never>
}

public class InvestHomeRepository: BaseRepository, InvestHomeRepositoryProtocol {
    // TODO: make loadNotifications remote
    public func loadNotifications(page: Int) -> AnyPublisher<BaseResponse<InvestNotificationData, EmptyData>, Never> {
        return Future { promise in
            promise(.success(
                BaseResponse(
                    status: .success,
                    error: nil,
                    response: InvestNotificationData.mock(page: page),
                    code: 200,
                    errors: nil
                )
            ))
        }.eraseToAnyPublisher()
    }
    
    public func loadInvests(page: Int) -> AnyPublisher<BaseResponse<InvestorContractData, EmptyData>, Never> {
        let api: InvestorApi = .contracts(page: page)
        return manager.request(api: api)
    }
    
    public func loadInvestorAccount() -> AnyPublisher<BaseResponse<InvestorAccountData, EmptyData>, Never> {
        let api: InvestorApi = .account
        return manager.request(api: api)
    }
    
    public func storeContract(model: AddContractRequest) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never> {
        let api: InvestorApi = .addContract(model: model)
        return manager.request(api: api)
    }
    
    public func loadContract(id: Int) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never> {
        let api: InvestorApi = .contract(id: id)
        return manager.request(api: api)
    }
    
    public func loadContractHistory(id: Int) -> AnyPublisher<BaseResponse<ContractHistoryData, EmptyData>, Never> {
        let api: InvestorApi = .contractHistory(id: id)
        return manager.request(api: api)
    }
    
    public func laodContractChart(id: Int) -> AnyPublisher<BaseResponse<ContractChartData, EmptyData>, Never> {
        let api: InvestorApi = .contractChart(id: id)
        return manager.request(api: api)
    }
    
    public func toggleContractStatus(id: Int, model: ToggleContractStatusRequest) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never> {
        let api: InvestorApi = .toggleContractStatus(id: id, model: model)
        return manager.request(api: api)
    }
    
    public func deleteContract(id: Int) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never> {
        let api: InvestorApi = .deleteContract(id: id)
        return manager.request(api: api)
    }
    
    public func loadWithdrawHistory(id: Int) -> AnyPublisher<BaseResponse<InvestProfitHistoryData, EmptyData>, Never> {
        let api: InvestorApi = .withdrawHistory(id: id)
        return manager.request(api: api)
    }
}
