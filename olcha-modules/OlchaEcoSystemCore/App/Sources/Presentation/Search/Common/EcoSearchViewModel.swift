import UIKit
import OlchaUI
import OlchaCore
import Combine

public class EcoSearchViewModel: BaseViewModel {
    
    public var searchSubject = PassthroughSubject<String, Never>()
    @Published public var searchResults: LoadingState<SearchData, BaseErrorType> = .standart
    
    private let loadSearchResultsUseCase: LoadSearchResultsUseCaseProtocol
    
    public init(loadSearchResultsUseCase: LoadSearchResultsUseCaseProtocol) {
        self.loadSearchResultsUseCase = loadSearchResultsUseCase
    }
    
    public func search() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { query -> AnyPublisher<BaseResponse<SearchData, EmptyData>, Never> in
                guard !query.isEmpty else { return .empty() }
                return self.loadSearchResults(query: query)
            }
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    searchResults = .success(baseResponse.response)
                case .canceled:
                    break
                default:
                    searchResults = .failure(.init(message: baseResponse.error))
                }
            }
            .store(in: &bag)
    }
    
    public func loadSearchResults(query: String) -> AnyPublisher<BaseResponse<SearchData, EmptyData>, Never> {
        guard searchResults != .loading else { return .empty() }
        searchResults = .loading
        return loadSearchResultsUseCase.execute(query: query)
//            .sink { [weak self] baseResponse in
//                guard let self else { return }
//                switch baseResponse.status {
//                case .success:
//                    searchResults = .success(baseResponse.response)
//                default:
//                    searchResults = .failure(.init(message: baseResponse.error))
//                }
//            }.store(in: &bag)
    }
    
}
