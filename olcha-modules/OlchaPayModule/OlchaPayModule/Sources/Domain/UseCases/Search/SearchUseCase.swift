//
//  SearchUseCase.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/04/23.
//

import Foundation
import Combine
import OlchaCore
public protocol SearchProvidersProtocol {
    func execute(filter: SearchFilter) -> AnyPublisher<BaseResponse<ProvidersData, EmptyData>, Never>
}

public enum SearchUseCase {
    public class LoadProviders: SearchProvidersProtocol {
        private let repository: SearchRepositoryProtocol
        
        public init(repository: SearchRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filter: SearchFilter) -> AnyPublisher<BaseResponse<ProvidersData, EmptyData>, Never> {
            repository.searchProviders(filter: filter)
        }
    }
}
