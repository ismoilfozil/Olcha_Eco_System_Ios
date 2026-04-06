//
//  HelpUseCaseAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject

final public class HelpUseCaseAssembly: Assembly {
    
    public func assemble(container: Container) {
        container.register(StoreFeedbackUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(HelpRepositoryProtocol.self)!
            return HelpUseCase.StoreFeedback(repository: repository)
        }
        
        container.register(LoadSuggestionsUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(SuggestionRepositoryProtocol.self)!
            return SuggestionUseCase.LoadSuggestions(repository: repository)
        }
        
        container.register(LoadSuggestionUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(SuggestionRepositoryProtocol.self)!
            return SuggestionUseCase.LoadSuggestion(repository: repository)
        }
    }
    
}
