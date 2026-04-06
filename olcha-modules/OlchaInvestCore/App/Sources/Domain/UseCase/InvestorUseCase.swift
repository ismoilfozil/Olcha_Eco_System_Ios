//
//  InvestorUseCase.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Combine
import OlchaCore

public protocol LoadInvestsProtocol {
    func execute(page: Int) -> AnyPublisher<BaseResponse<InvestorContractData, EmptyData>, Never>
}

public protocol LoadAccountProtocol {
    func execute() -> AnyPublisher<BaseResponse<InvestorAccountData, EmptyData>, Never>
}

public protocol StoreContractProtocol {
    func execute(model: AddContractRequest) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never>
}

public protocol LoadContractProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never>
}

public protocol LoadContractHistoryProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<ContractHistoryData, EmptyData>, Never>
}

public protocol LoadContractChartProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<ContractChartData, EmptyData>, Never>
}

public protocol LoadWithdrawHistoryProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<InvestProfitHistoryData, EmptyData>, Never>
}


public enum InvestorUseCase {
    
    public class LoadInvests: LoadInvestsProtocol {
        private let repository: InvestHomeRepositoryProtocol
        
        public init(repository: InvestHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(page: Int) -> AnyPublisher<BaseResponse<InvestorContractData, EmptyData>, Never> {
            repository.loadInvests(page: page)
        }   
    }
    
    public class LoadAccount: LoadAccountProtocol {
        private let repository: InvestHomeRepositoryProtocol
        
        public init(repository: InvestHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<InvestorAccountData, EmptyData>, Never> {
            repository.loadInvestorAccount()
        }
    }
    
    public class StoreContract: StoreContractProtocol {
        private let repository: InvestHomeRepositoryProtocol
        
        public init(repository: InvestHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: AddContractRequest) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never> {
            repository.storeContract(model: model)
        }
    }
    
    public class LoadContract: LoadContractProtocol {
        private let repository: InvestHomeRepositoryProtocol
        
        public init(repository: InvestHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<InvestorContractModel, EmptyData>, Never> {
            repository.loadContract(id: id)
        }
    }
    
    public class LoadContractHistory: LoadContractHistoryProtocol {
        private let repository: InvestHomeRepositoryProtocol
        
        public init(repository: InvestHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<ContractHistoryData, EmptyData>, Never> {
            repository.loadContractHistory(id: id)
        }
    }
    
    public class LoadContractChart: LoadContractChartProtocol {
        private let repository: InvestHomeRepositoryProtocol
        
        public init(repository: InvestHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<ContractChartData, EmptyData>, Never> {
            repository.laodContractChart(id: id)
        }
    }
 
    public class LoadWithdrawHistory: LoadWithdrawHistoryProtocol {
        private let repository: InvestHomeRepositoryProtocol
        
        init(repository: InvestHomeRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<InvestProfitHistoryData, EmptyData>, Never> {
            repository.loadWithdrawHistory(id: id)
        }
    }
}
