//
//  VerifyBankCard+UseCase.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 14/07/23.
//

import Foundation
import Combine
import OlchaCore
import OlchaUtils
import OlchaBankCards

extension BillingUseCase {
    
    public class UploadBillingBankCard: UploadBankCardProtocol {
        
        private var bag = Set<AnyCancellable>()
        private let repository: BankCardRepositoryProtocol
        
        public init(repository: BankCardRepositoryProtocol) {
            self.repository = repository
        }
#warning("billing message")
        public func execute(model: VerificationUploadBankCard, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            return repository.uploadBankCard(
                model: model,
                filter: filter
            )
        }
        
    }
    
}
