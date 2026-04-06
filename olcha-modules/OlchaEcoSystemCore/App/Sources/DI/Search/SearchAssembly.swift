import Swinject

final class SearchAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(EcoSearchViewModel.self) { r in
            let loadSearchResultsUseCase = r.resolve(LoadSearchResultsUseCaseProtocol.self)!
            return EcoSearchViewModel(loadSearchResultsUseCase: loadSearchResultsUseCase)
        }
        
        container.register(EcoSearchViewController.self) { r in
            let viewModel = r.resolve(EcoSearchViewModel.self)!
            return EcoSearchViewController(viewModel: viewModel)
        }
    }
    
}
