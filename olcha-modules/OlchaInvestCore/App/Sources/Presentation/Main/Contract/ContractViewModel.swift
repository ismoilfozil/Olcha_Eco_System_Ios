//
//  ContractViewModel.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 12/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaCore
import Combine

public class ContractViewModel: BaseViewModel {
    
    @Published public var loadedAllContractData: LoadingState<Bool, BaseErrorType> = .standart
    @Published public var contract: LoadingState<InvestorContractModel, BaseErrorType> = .standart
    @Published public var contractHistory: LoadingState<ContractHistoryData, BaseErrorType> = .standart
    @Published public var contractChart: LoadingState<ContractChartData, BaseErrorType> = .standart
    @Published public var hasContractStatusChanged: LoadingState<InvestorContractModel, BaseErrorType> = .standart
    @Published public var hasAutoWithdrawalStatusChanged: LoadingState<ToggleAutoWithdrawalResponse, BaseErrorType> = .standart
    @Published public var widthdrawHistoryData: LoadingState<InvestProfitHistoryData, BaseErrorType> = .standart
    
    
    private let loadContractUseCase: LoadContractProtocol
    private let loadContractHistoryUseCase: LoadContractHistoryProtocol
    private let loadContractChartUseCase: LoadContractChartProtocol
    private let toggleContractStatusUseCase: ToggleContractStatusProtocol
    private let toggleAutoWithdrawalStatusUseCase: ToggleAutoWithdrawalStatusProtocol
    private let deleteContractUseCase: DeleteContractUseCaseProtocol
    private let loadWithdrawHistory: LoadWithdrawHistoryProtocol
    
    public init(
        loadContractUseCase: LoadContractProtocol,
        loadContractHistoryUseCase: LoadContractHistoryProtocol,
        loadContractChartUseCase: LoadContractChartProtocol,
        toggleContractStatusUseCase: ToggleContractStatusProtocol,
        toggleAutoWithdrawalStatusUseCase: ToggleAutoWithdrawalStatusProtocol,
        deleteContractUseCase: DeleteContractUseCaseProtocol,
        loadWithdrawHistory: LoadWithdrawHistoryProtocol
    ) {
        self.loadContractUseCase = loadContractUseCase
        self.loadContractHistoryUseCase = loadContractHistoryUseCase
        self.loadContractChartUseCase = loadContractChartUseCase
        self.toggleContractStatusUseCase = toggleContractStatusUseCase
        self.toggleAutoWithdrawalStatusUseCase = toggleAutoWithdrawalStatusUseCase
        self.deleteContractUseCase = deleteContractUseCase
        self.loadWithdrawHistory = loadWithdrawHistory
    }
    
    public func combineContractData() {
        loadedAllContractData = .loading
        Publishers.CombineLatest3($contract, $contractChart, $contractHistory)
            .sink { [weak self] (contract, chart, history) in
                guard let self, contract.value != nil else {
                    self?.loadedAllContractData = .failure(nil)
                    return
                }
                guard chart.value != nil, history.value != nil else {
                    self.loadedAllContractData = .failure(nil)
                    return
                }
                loadedAllContractData = .success(true)
            }.store(in: &bag)
    }
    
    public func loadContract(id: Int) {
        contract = .loading
        loadContractUseCase.execute(id: id)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    contract = .success(baseResponse.response)
                default:
                    contract = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    public func loadContractHistory(id: Int) {
        contractHistory = .loading
        loadContractHistoryUseCase.execute(id: id)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    contractHistory = .success(baseResponse.response)
                default:
                    contractHistory = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    public func loadContractChart(id: Int) {
        contractChart = .loading
        loadContractChartUseCase.execute(id: id)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    contractChart = .success(baseResponse.response)
                default:
                    contractChart = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    public func toggleContractStatus(id: Int, status: Bool, comment: String) {
        guard hasContractStatusChanged != .loading else { return }
        hasContractStatusChanged = .loading
        let status = status ? ToggleContractStatusRequest.ContractStatus.enable : ToggleContractStatusRequest.ContractStatus.disable
        let request = ToggleContractStatusRequest(status: status.rawValue, comment: comment)
        toggleContractStatusUseCase.execute(id: id, model: request)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    hasContractStatusChanged = .success(baseResponse.response)
                default:
                    hasContractStatusChanged = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
    public func toggleAutoWithdrawalStatus(contractId: Int, completion: (() -> Void)?) {
        guard hasAutoWithdrawalStatusChanged != .loading else { return }
        hasAutoWithdrawalStatusChanged = .loading
        toggleAutoWithdrawalStatusUseCase.execute(contractId: contractId)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    hasAutoWithdrawalStatusChanged = .success(baseResponse.response)
                    completion?()
                default:
                    hasAutoWithdrawalStatusChanged = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    public func deleteContract(id: Int) {
        guard hasContractStatusChanged != .loading else { return }
        hasContractStatusChanged = .loading
        deleteContractUseCase.execute(id: id)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    hasContractStatusChanged = .success(baseResponse.response)
                default:
                    hasContractStatusChanged = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
    public func loadWithdrawHistory(id: Int) {
        guard widthdrawHistoryData != .loading else { return }
        widthdrawHistoryData = .loading
        loadWithdrawHistory.execute(id: id)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    widthdrawHistoryData = .success(baseResponse.response)
                default:
                    widthdrawHistoryData = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
}
