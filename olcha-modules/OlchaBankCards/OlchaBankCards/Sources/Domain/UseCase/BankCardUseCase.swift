//
//  BankCardUseCase.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 22/06/23.
//

import Foundation
import Combine
import OlchaCore
import OlchaUtils
public protocol VerifyBankCardPhoneProtocol {
    func execute(model: VerificationUploadCode, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BankCardData, CardUploadValidationError>, Never>
}

public extension VerifyBankCardPhoneProtocol {
    func execute(model: VerificationUploadCode, filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<BankCardData, CardUploadValidationError>, Never> {
        self.execute(model: model, filter: filter)
    }
}

public protocol UploadBankCardProtocol {
    func execute(model: VerificationUploadBankCard, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public extension UploadBankCardProtocol {
    func execute(model: VerificationUploadBankCard, filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        self.execute(model: model, filter: filter)
    }
}

public protocol LoadBankCardsProtocol {
    func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BankCardsData, EmptyData>, Never>
}
public extension LoadBankCardsProtocol {
    func execute(filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<BankCardsData, EmptyData>, Never> {
        self.execute(filter: filter)
    }
}

public protocol MakeDefaultProtocol {
    func execute(id: Int, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}
public extension MakeDefaultProtocol {
    func execute(id: Int, filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        self.execute(id: id, filter: filter)
    }
}

public protocol RemoveCardProtocol {
    func execute(id: Int, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}
public extension RemoveCardProtocol {
    func execute(id: Int, filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        self.execute(id: id, filter: filter)
    }
}


public enum BankCardUseCase {
    public class VerifyBankCardPhone: VerifyBankCardPhoneProtocol {
        private let repository: BankCardRepositoryProtocol
        public init(repository: BankCardRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: VerificationUploadCode, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BankCardData, CardUploadValidationError>, Never> {
            return repository.verifyBankCardPhone(model: model, filter: filter)
        }
    }
    
    public class UploadBankCard: UploadBankCardProtocol {
        private let repository: BankCardRepositoryProtocol
        public init(repository: BankCardRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: VerificationUploadBankCard, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.uploadBankCard(model: model, filter: filter)
        }
    }

    public class LoadBankCards: LoadBankCardsProtocol {
        private let repository: BankCardRepositoryProtocol
        public init(repository: BankCardRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BankCardsData, EmptyData>, Never> {
            repository.loadEntities()
        }
    }

    public class MakeDefault: MakeDefaultProtocol {
        private let repository: BankCardRepositoryProtocol
        public init(repository: BankCardRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(id: Int, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.makeDefault(id: id, filter: filter)
        }
    }

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
