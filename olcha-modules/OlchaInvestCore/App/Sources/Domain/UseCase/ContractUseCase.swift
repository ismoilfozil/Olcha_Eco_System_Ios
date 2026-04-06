//
//  ContractUseCase.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 21/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Combine
import OlchaCore

public protocol ToggleContractStatusProtocol {
    func execute(id: Int, model: ToggleContractStatusRequest) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never>
}

public protocol DeleteContractUseCaseProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never>
}

public enum ContractUseCase {
    
    public class ToggleContractStatus: ToggleContractStatusProtocol {
        private let repository: InvestHomeRepositoryProtocol
        
        public init(repository: InvestHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int, model: ToggleContractStatusRequest) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never> {
            repository.toggleContractStatus(id: id, model: model)
        }
    }
    
    public class DeleteContract: DeleteContractUseCaseProtocol {
        private let repository: InvestHomeRepositoryProtocol
        
        public init(repository: InvestHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never> {
            repository.deleteContract(id: id)
        }
    }
    
}
