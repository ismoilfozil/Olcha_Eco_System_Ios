//
//  PackagesUseCase.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 24/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Combine
import OlchaCore

public protocol LoadPackagesProtocol {
    func execute(page: Int) -> AnyPublisher<BaseResponse<InvestmentData, EmptyData>, Never>
}

public protocol LoadPackageProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<InvestmentModel, EmptyData>, Never>
}

public enum PackagesUseCase {
    
    public class LoadPackages: LoadPackagesProtocol {
        private let repository: InvestPackagesRepositoryProtocol
        
        public init(repository: InvestPackagesRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(page: Int) -> AnyPublisher<BaseResponse<InvestmentData, EmptyData>, Never> {
            repository.loadPackages(page: page)
        }
    }
    
    public class LoadPackage: LoadPackageProtocol {
        
        private let repository: InvestPackagesRepositoryProtocol
        
        public init(repository: InvestPackagesRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<InvestmentModel, EmptyData>, Never> {
            repository.loadPackage(id: id)
        }
        
    }
    
}

