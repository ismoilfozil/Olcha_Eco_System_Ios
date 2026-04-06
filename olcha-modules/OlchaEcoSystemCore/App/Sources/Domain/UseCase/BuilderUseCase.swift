import Combine
import OlchaCore

public protocol LoadBuildersUseCaseProtocol {
    func execute() -> AnyPublisher<BaseResponse<BuilderData, EmptyData>, Never>
}

public protocol LoadSearchResultsUseCaseProtocol {
    func execute(query: String) -> AnyPublisher<BaseResponse<SearchData, EmptyData>, Never>
}

public protocol LoadBalanceUseCaseProtocol {
    func execute() -> AnyPublisher<BaseResponse<BalanceData, EmptyData>, Never>
}

public protocol LoadBonusBalanceUseCaseProtocol {
    func execute() -> AnyPublisher<BaseResponse<BonusData, EmptyData>, Never>
}

public enum BuilderUseCase {
    
    public class LoadBuilders: LoadBuildersUseCaseProtocol {
        private let repository: BuildRepositoryProtocol
        
        public init(repository: BuildRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<BuilderData, EmptyData>, Never> {
            return repository.loadBuilders()
        }
    }

    public class LoadSearchResults: LoadSearchResultsUseCaseProtocol {
        private let repository: BuildRepositoryProtocol
        
        public init(repository: BuildRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(query: String) -> AnyPublisher<BaseResponse<SearchData, EmptyData>, Never> {
            return repository.loadSearchResults(query: query)
        }
    }
    
    public class LoadBalance: LoadBalanceUseCaseProtocol {
        
        private let repository: BuildRepositoryProtocol
        
        public init(repository: BuildRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<BalanceData, EmptyData>, Never> {
            return repository.loadBalance()
        }
    }

    public class LoadBonusBalance: LoadBonusBalanceUseCaseProtocol {
        
        private let repository: BuildRepositoryProtocol
        
        public init(repository: BuildRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<BonusData, EmptyData>, Never> {
            return repository.loadBonusBalance()
        }
    }

}
