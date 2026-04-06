//
//  NewsRepository.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 24/03/23.
//

import Foundation
import Combine
import OlchaCore

public protocol NewsRepositoryProtocol {
    func loadNews(page: Int) -> AnyPublisher<(BaseResponse<NewsData, EmptyData>), Never>
}

public class NewsRepository: BaseRepository, NewsRepositoryProtocol {
    public func loadNews(page: Int) -> AnyPublisher<(BaseResponse<NewsData, EmptyData>), Never> {
        let api: NewsAPI = .news(page: page)
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
    
}
