//
//  SuggestionUseCase.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Combine
import OlchaCore

public protocol LoadSuggestionsUseCaseProtocol {
    func execute() -> AnyPublisher<BaseResponse<SuggestionData, EmptyData>, Never>
}

public protocol LoadSuggestionUseCaseProtocol {
    func execute(id: Int) -> AnyPublisher<BaseResponse<SuggestionItemModel, EmptyData>, Never>
}

public enum SuggestionUseCase {
    
    public class LoadSuggestions: LoadSuggestionsUseCaseProtocol {
        private let repository: SuggestionRepositoryProtocol
        
        public init(repository: SuggestionRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute() -> AnyPublisher<BaseResponse<SuggestionData, EmptyData>, Never> {
            repository.loadSuggestions()
        }
    }
    
    public class LoadSuggestion: LoadSuggestionUseCaseProtocol {
        private let repository: SuggestionRepositoryProtocol
        
        public init(repository: SuggestionRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int) -> AnyPublisher<BaseResponse<SuggestionItemModel, EmptyData>, Never> {
            repository.loadSuggestion(postId: id)
        }
    }
    
}
