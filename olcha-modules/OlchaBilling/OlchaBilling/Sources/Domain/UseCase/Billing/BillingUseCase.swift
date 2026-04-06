//
//  BillingUseCase.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 21/06/23.
//

import Foundation
import Combine
import OlchaUI
import OlchaCore
import OlchaUtils
import OlchaBankCards

public protocol LoadPaymentTypesProtocol {
    func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentsData, EmptyData>, Never>
}

public protocol MakePaymentOtpProtocol {
    func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentData, EmptyData>, Never>
}

public protocol MakePaymentProtocol {
    func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public protocol GeneratePaymentLinkProtocol {
    func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentData, EmptyData>, Never>
}

public protocol LoadBillingEntitiesProtocol {
    func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingEntitiesData, EmptyData>, Never>
}

public protocol LoadBillingCurrencyProtocol {
    func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingCurrencyData, EmptyData>, Never>
}

public enum BillingUseCase {
    public class LoadPaymentTypes: LoadPaymentTypesProtocol {
        private let repository: BillingRepositoryProtocol
        
        public init(repository: BillingRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentsData, EmptyData>, Never> {
            repository.loadPaymentTypes(filter: filter)
        }
        
    }
    
    public class MakePaymentOtp: MakePaymentOtpProtocol {
        private let repository: BillingRepositoryProtocol
        
        public init(repository: BillingRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentData, EmptyData>, Never> {
            repository.makePaymentOtp(filter: filter)
        }
    }
    
    public class MakePayment: MakePaymentProtocol {
        private let repository: BillingRepositoryProtocol
        
        public init(repository: BillingRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
            repository.makePayment(filter: filter)
        }
    }
    
    public class GeneratePaymentLink: GeneratePaymentLinkProtocol {
        private let repository: BillingRepositoryProtocol
        
        public init(repository: BillingRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentData, EmptyData>, Never> {
            repository.generateLink(filter: filter)
        }
    }
    
    public class LoadBillingEntities: LoadBillingEntitiesProtocol {
        private let repository: BillingRepositoryProtocol
        
        public init(repository: BillingRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingEntitiesData, EmptyData>, Never> {
            repository.loadEntities(filter: filter)
        }
    }
    
    public class LoadBillingCurrency: LoadBillingCurrencyProtocol {
        private let repository: BillingRepositoryProtocol
        
        public init(repository: BillingRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingCurrencyData, EmptyData>, Never> {
            repository.loadCurrency(filter: filter)
        }
    }
}
