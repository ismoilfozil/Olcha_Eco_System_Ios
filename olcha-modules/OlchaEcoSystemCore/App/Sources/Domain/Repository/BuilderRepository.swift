import Combine
import OlchaCore

public protocol BuildRepositoryProtocol {
    func loadBuilders() -> AnyPublisher<BaseResponse<BuilderData, EmptyData>, Never>
    func loadSearchResults(query: String) -> AnyPublisher<BaseResponse<SearchData, EmptyData>, Never>
    func loadBalance() -> AnyPublisher<BaseResponse<BalanceData, EmptyData>, Never>
    func loadBonusBalance() -> AnyPublisher<BaseResponse<BonusData, EmptyData>, Never>
}

public class BuildRepository: BaseRepository, BuildRepositoryProtocol {
    
    public func loadBuilders() -> AnyPublisher<BaseResponse<BuilderData, EmptyData>, Never> {
        let api: BuilderApi = .builders
        return manager.request(api: api, isCancellable: true)
    }
    
    public func loadSearchResults(query: String) -> AnyPublisher<BaseResponse<SearchData, EmptyData>, Never> {
        let api: BuilderApi = .search(query: query)
        return manager.request(api: api, isCancellable: true)
    }
    
    public func loadBalance() -> AnyPublisher<BaseResponse<BalanceData, EmptyData>, Never> {
        let api: BuilderApi = .balance
        return manager.request(api: api, isCancellable: true)
    }
    
    public func loadBonusBalance() -> AnyPublisher<BaseResponse<BonusData, EmptyData>, Never> {
        let api: BuilderApi = .bonus
        return manager.request(api: api, isCancellable: true)
    }
    
}
