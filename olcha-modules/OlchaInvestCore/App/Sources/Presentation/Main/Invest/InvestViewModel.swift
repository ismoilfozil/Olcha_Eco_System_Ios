//
//  InvestViewModel.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 16/08/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaUI
import OlchaCore

public final class InvestViewModel: BaseViewModel {
    
    @Published public var isContractCreated: LoadingState<InvestorContractModel, BaseErrorType> = .standart
    
    private let storeContractUseCase: StoreContractProtocol

    public init(storeContractUseCase: StoreContractProtocol) {
        self.storeContractUseCase = storeContractUseCase
    }
    
    public func storeContract(model: AddContractRequest) {
        guard isContractCreated != .loading else { return }
        isContractCreated = .loading
        storeContractUseCase.execute(model: model)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    isContractCreated = .success(baseResponse.response)
                default:
                    isContractCreated = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
    }
    
}
