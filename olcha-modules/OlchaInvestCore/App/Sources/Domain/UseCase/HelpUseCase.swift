//
//  HelpUseCase.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Combine
import OlchaCore

public protocol StoreFeedbackUseCaseProtocol {
    func execute(investorId: Int, message: String) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public enum HelpUseCase {
    
    public class StoreFeedback: StoreFeedbackUseCaseProtocol {
        private let repository: HelpRepositoryProtocol
        
        public init(repository: HelpRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(investorId: Int, message: String) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.storeFeedback(investorId: investorId, message: message)
        }
    }
    
}
