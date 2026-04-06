//
//  BarcodeRepository.swift
//  OlchaPayModule
//
//  Created by Claude Code
//

import Foundation
import Combine
import OlchaCore

public protocol BarcodeRepositoryProtocol {
    func generateBarcode(userId: Int) -> AnyPublisher<BaseResponse<BarcodeResponse, EmptyData>, Never>
}

public class BarcodeRepository: BaseRepository, BarcodeRepositoryProtocol {
    public func generateBarcode(userId: Int) -> AnyPublisher<BaseResponse<BarcodeResponse, EmptyData>, Never> {
        let api: BarcodeAPI = .generate(userId: userId)
        return manager.request(api: api,
                               isSingleRequest: false,
                               isCancellable: false)
    }
}
