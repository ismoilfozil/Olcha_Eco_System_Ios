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
    
    public class VerifyBillingBankCardPhone: VerifyBankCardPhoneProtocol {
        
        private var bag = Set<AnyCancellable>()
        private let repository: BankCardRepositoryProtocol
        
        public init(repository: BankCardRepositoryProtocol) {
            self.repository = repository
        }
#warning("billing message")
        public func execute(model: VerificationUploadCode, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BankCardData, CardUploadValidationError>, Never> {
            return repository.verifyBankCardPhone(
                model: model,
                filter: filter
            )
        }
    }
    
}
