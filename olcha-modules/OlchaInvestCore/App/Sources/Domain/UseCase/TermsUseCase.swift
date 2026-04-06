//
//  TermsUseCase.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Combine
import OlchaCore

public protocol LoadTermsProtocol {
    func execute(termId: Int) -> AnyPublisher<BaseResponse<InvestmentData, EmptyData>, Never>
}

public enum TermsUseCase {
    
    public class LoadTerms: LoadTermsProtocol {
        
        private let repository: InvestPackagesRepositoryProtocol
        
        public init(repository: InvestPackagesRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(termId: Int) -> AnyPublisher<BaseResponse<InvestmentData, EmptyData>, Never> {
            repository.loadTerms(termId: termId)
        }
        
    }
    
}
