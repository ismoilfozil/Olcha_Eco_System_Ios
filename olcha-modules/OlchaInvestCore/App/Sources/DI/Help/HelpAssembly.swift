//
//  HelpAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 05/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject
import OlchaCommon
import OlchaUtils

public final class HelpAssembly: Assembly {
    
    public func assemble(container: Container) {
        container.register(HelpViewController.self) { _ in
            return HelpViewController()
        }
        
        container.register(HelpViewModel.self) { resolver in
            let storeFeedbackUseCase = resolver.resolve(StoreFeedbackUseCaseProtocol.self)!
            return HelpViewModel(storeFeedbackUseCase: storeFeedbackUseCase)
        }
        
        container.register(WriteUsViewController.self) { resolver in
            let commonContainer = CommonDIContainer.shared
            let organization = Organization.invest
            let viewModel: CommonViewModel = commonContainer.resolve(argument: organization)
            return WriteUsViewController(viewModel: viewModel)
        }
        
        container.register(SuggestionViewModel.self) { resolver in
            let loadSuggestionsUseCase = resolver.resolve(LoadSuggestionsUseCaseProtocol.self)!
            let loadSuggestionUseCase = resolver.resolve(LoadSuggestionUseCaseProtocol.self)!
            return SuggestionViewModel(loadSuggestionsUseCase: loadSuggestionsUseCase, loadSuggestionUseCase: loadSuggestionUseCase)
        }
        
        container.register(SuggestionViewController.self) { resolver in
            let viewModel = resolver.resolve(SuggestionViewModel.self)!
            return SuggestionViewController(viewModel: viewModel)
        }
        
        container.register(SuggestionDetailViewController.self) { resolver in
            let viewModel = resolver.resolve(SuggestionViewModel.self)!
            return SuggestionDetailViewController(viewModel: viewModel)
        }
    }
    
}
