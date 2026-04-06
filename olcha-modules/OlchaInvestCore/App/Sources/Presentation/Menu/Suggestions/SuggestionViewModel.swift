//
//  SuggestionViewModel.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaCore

public class SuggestionViewModel: BaseViewModel {
    
    @Published public var suggestions: LoadingState<SuggestionData, BaseErrorType> = .standart
    @Published public var suggestion: LoadingState<SuggestionItemModel, BaseErrorType> = .standart
    
    private let loadSuggestionsUseCase: LoadSuggestionsUseCaseProtocol
    private let loadSuggestionUseCase: LoadSuggestionUseCaseProtocol
    
    public init(
        loadSuggestionsUseCase: LoadSuggestionsUseCaseProtocol,
        loadSuggestionUseCase: LoadSuggestionUseCaseProtocol
    ) {
        self.loadSuggestionsUseCase = loadSuggestionsUseCase
        self.loadSuggestionUseCase = loadSuggestionUseCase
    }
    
    public func loadSuggestions() {
        guard suggestions != .loading else { return }
        suggestions = .loading
        loadSuggestionsUseCase.execute()
            .sink { [weak self] response in
                guard let self else { return }
                switch response.status {
                case .success:
                    suggestions = .success(response.response)
                default:
                    suggestions = .failure(.init(message: response.error))
                }
            }.store(in: &bag)
    }
    
    public func loadSuggestion(id: Int) {
        guard suggestion != .loading else { return }
        suggestion = .loading
        loadSuggestionUseCase.execute(id: id)
            .sink { [weak self] response in
                guard let self else { return }
                switch response.status {
                case .success:
                    suggestion = .success(response.response)
                default:
                    suggestion = .failure(.init(message: response.error))
                }
            }.store(in: &bag)
    }
    
}

