//
//  SearchRepository.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/04/23.
//

import Foundation
import Combine
import OlchaCore
public protocol SearchRepositoryProtocol {
    func searchProviders(filter: SearchFilter) -> AnyPublisher<(BaseResponse<ProvidersData, EmptyData>), Never>
}

public class SearchRepository: BaseRepository, SearchRepositoryProtocol {
    public func searchProviders(filter: SearchFilter) -> AnyPublisher<(BaseResponse<ProvidersData, EmptyData>), Never> {
        let api: SearchAPI = .providers(filter: filter)
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: true)
    }
}
