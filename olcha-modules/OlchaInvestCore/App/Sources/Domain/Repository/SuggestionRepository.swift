//
//  SuggestionRepository.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaCore
import Combine

public protocol SuggestionRepositoryProtocol {
    func loadSuggestions() -> AnyPublisher<BaseResponse<SuggestionData, EmptyData>, Never>
    func loadSuggestion(postId: Int) -> AnyPublisher<BaseResponse<SuggestionItemModel, EmptyData>, Never>
}

public class SuggestionRepository: BaseRepository, SuggestionRepositoryProtocol {

    public func loadSuggestions() -> AnyPublisher<BaseResponse<SuggestionData, EmptyData>, Never> {
        let api: SuggestionApi = .loadSuggestions
        return manager.request(api: api)
    }
    
    public func loadSuggestion(postId: Int) -> AnyPublisher<BaseResponse<SuggestionItemModel, EmptyData>, Never> {
        let api: SuggestionApi = .loadSuggestion(id: postId)
        return manager.request(api: api)
    }
    
}

