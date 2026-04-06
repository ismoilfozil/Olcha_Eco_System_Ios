//
//  NewsUseCase.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/03/23.
//

import Foundation
import Combine
import OlchaCore
public protocol LoadNewsProtocol {
    func execute(page: Int) -> AnyPublisher<BaseResponse<NewsData, EmptyData>, Never>
}

enum NewsUseCase {
    public class LoadNews: LoadNewsProtocol {
        private let repository: NewsRepositoryProtocol
        
        public init(repository: NewsRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(page: Int) -> AnyPublisher<BaseResponse<NewsData, EmptyData>, Never> {
            return repository.loadNews(page: page)
        }
    }
}
