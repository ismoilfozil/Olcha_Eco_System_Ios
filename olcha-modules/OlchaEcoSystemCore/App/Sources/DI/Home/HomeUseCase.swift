import Swinject

final class HomeUseCaseAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LoadBuildersUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(BuildRepositoryProtocol.self)!
            return BuilderUseCase.LoadBuilders(repository: repository)
        }
        
        container.register(LoadBalanceUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(BuildRepositoryProtocol.self)!
            return BuilderUseCase.LoadBalance(repository: repository)
        }

        container.register(LoadBonusBalanceUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(BuildRepositoryProtocol.self)!
            return BuilderUseCase.LoadBonusBalance(repository: repository)
        }
    }
    
}
