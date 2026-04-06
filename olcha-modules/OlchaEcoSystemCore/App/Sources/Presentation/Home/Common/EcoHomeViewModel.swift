import UIKit
import OlchaUI
import OlchaCore
import OlchaAuth

public class EcoHomeViewModel: BaseViewModel {
    
    @Published public var builder: LoadingState<BuilderData, BaseErrorType> = .standart
    @Published public var balance: LoadingState<BalanceData, BaseErrorType> = .standart
    @Published public var bonusBalance: LoadingState<BonusData, BaseErrorType> = .standart
    
    private let loadBuildersUseCase: LoadBuildersUseCaseProtocol
    private let loadBalanceUseCase: LoadBalanceUseCaseProtocol
    private let loadBonusBalanceUseCase: LoadBonusBalanceUseCaseProtocol
    
    public init(
        loadBuildersUseCase: LoadBuildersUseCaseProtocol,
        loadBalanceUseCase: LoadBalanceUseCaseProtocol,
        loadBonusBalanceUseCase: LoadBonusBalanceUseCaseProtocol
    ) {
        self.loadBuildersUseCase = loadBuildersUseCase
        self.loadBalanceUseCase = loadBalanceUseCase
        self.loadBonusBalanceUseCase = loadBonusBalanceUseCase
    }
    
    public func loadBuilders() {
        guard builder != .loading else { return }
        builder = .loading
        loadBuildersUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    builder = .success(baseResponse.response)
                default:
                    builder = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    public func loadBalance() {
        guard balance != .loading, AuthGlobalDefaults.isUser() else { return }
        balance = .loading
        loadBalanceUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    balance = .success(baseResponse.response)
                default:
                    balance = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
    public func loadBonusBalance() {
        guard bonusBalance != .loading, AuthGlobalDefaults.isUser() else { return }
        bonusBalance = .loading
        loadBonusBalanceUseCase.execute()
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    bonusBalance = .success(baseResponse.response)
                default:
                    bonusBalance = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }
    
}
