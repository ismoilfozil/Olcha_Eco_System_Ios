import Swinject

final class SearchUseCaseAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LoadSearchResultsUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(BuildRepositoryProtocol.self)!
            return BuilderUseCase.LoadSearchResults(repository: repository)
        }
    }
    
}
