//
//  BarcodeUseCase.swift
//  OlchaPayModule
//
//  Created by Claude Code
//

import Foundation
import Combine
import OlchaCore

public protocol GenerateBarcodeProtocol {
    func execute(userId: Int) -> AnyPublisher<BaseResponse<BarcodeResponse, EmptyData>, Never>
}

public enum BarcodeUseCase {
    public class GenerateBarcode: GenerateBarcodeProtocol {
        private let repository: BarcodeRepositoryProtocol

        public init(repository: BarcodeRepositoryProtocol) {
            self.repository = repository
        }

        public func execute(userId: Int) -> AnyPublisher<BaseResponse<BarcodeResponse, EmptyData>, Never> {
            return repository.generateBarcode(userId: userId)
        }
    }
}
