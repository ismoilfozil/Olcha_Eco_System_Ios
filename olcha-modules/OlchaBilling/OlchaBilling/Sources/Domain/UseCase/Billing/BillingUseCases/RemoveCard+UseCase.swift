//
//  Delete+UseCase.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 18/08/23.
//

import Foundation
import Combine
import OlchaCore
import OlchaUtils
import OlchaBankCards

extension BillingUseCase {
    public class RemoveCard: RemoveCardProtocol {
        private let repository: BankCardRepositoryProtocol
        
        public init(repository: BankCardRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.removeCard(id: id, filter: filter)
        }
        
    }
}
