//
//  NasiyaHomeViewModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 12/05/23.
//

import Foundation
import OlchaUI
import OlchaCore
import OlchaAuth

public class NasiyaHomeViewModel: BaseViewModel {
    
    @Published public var limit: LoadingState<InstallmentLimitBalanceData, BaseErrorType> = .standart
    @Published public var requestLimitState: LoadingState<LimitModel, BaseErrorType> = .standart
    
    private let loadLimitUseCase: LoadLimitProtocol
    private let requestLimitUseCase: RequestLimitProtocol
    
    public init(loadLimitUseCase: LoadLimitProtocol,
                requestLimitUseCase: RequestLimitProtocol) {
        self.loadLimitUseCase = loadLimitUseCase
        self.requestLimitUseCase = requestLimitUseCase
    }
    
    public func loadLimit() {
        guard limit != .loading, AuthGlobalDefaults.isUser() else { return }
        limit = .loading
        loadLimitUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    limit = .success(baseResponse.response)
                default:
                    limit = .failure(
                        .init(message: baseResponse.error)
                    )
                }
            }.store(in: &bag)
    }
    
    public func requestLimit() {
        requestLimitState = .loading
        requestLimitUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    loadLimitAfterRequest()
                default:
                    requestLimitState = .failure(
                        .init(message: baseResponse.error)
                    )
                }
            }.store(in: &bag)
    }
    
    private func loadLimitAfterRequest() {

        loadLimitUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    requestLimitState = .success(
                        .init(limit: baseResponse.response,
                              message: baseResponse.error)
                    )
                    break
                default:
                    requestLimitState = .failure(
                        .init(message: baseResponse.error)
                    )
                    break
                }
            }.store(in: &bag)
    }
    
}
