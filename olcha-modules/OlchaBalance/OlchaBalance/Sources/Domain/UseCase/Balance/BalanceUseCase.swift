//
//  BalanceUseCase.swift
//  OlchaBalance
//
//  Created by Elbek Khasanov on 06/07/23.
//

import Foundation
import OlchaCore
import OlchaUtils
import Combine
import OlchaBankCards

public protocol LoadBalanceProtocol {
    func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BalancesData, EmptyData>, Never>
}
public extension LoadBalanceProtocol {
    func execute(filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<BalancesData, EmptyData>, Never> {
        self.execute(filter: filter)
    }
}

public protocol LoadPaymentTypesProtocol {
    func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<PaymentTypeData, EmptyData>, Never>
}
public extension LoadPaymentTypesProtocol {
    func execute(filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<PaymentTypeData, EmptyData>, Never> {
        self.execute(filter: filter)
    }
}

public protocol MakePaymentTransactionProtocol {
    func execute(model: CardPaymentRequest, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<CardPaymentData, ValidationErrors>, Never>
}
public extension MakePaymentTransactionProtocol {
    func execute(model: CardPaymentRequest, filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<CardPaymentData, ValidationErrors>, Never> {
        self.execute(model: model, filter: filter)
    }
}

public protocol MakePaymentTransactionOTPProtocol {
    func execute(model: ProvideOTPPaymentRequest, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<CardPaymentData, ValidationErrors>, Never>
}

public protocol GenerateLinkProtocol {
    func execute(model: FillPaymentRequest, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<LinkPaymentData, ValidationErrors>, Never>
}
public extension GenerateLinkProtocol {
    func execute(model: FillPaymentRequest, filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<LinkPaymentData, ValidationErrors>, Never> {
        self.execute(model: model, filter: filter)
    }
}

public enum BalanceUseCase {
    public class LoadBalance: LoadBalanceProtocol {
        private let repository: BalanceRepositoryProtocol
        public init(repository: BalanceRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BalancesData, EmptyData>, Never> {
            repository.loadBalance()
        }
    }
    
    public class LoadPaymentTypes: LoadPaymentTypesProtocol {
        private let repository: BalanceRepositoryProtocol
        public init(repository: BalanceRepositoryProtocol) {
            self.repository = repository
        }
        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<PaymentTypeData, EmptyData>, Never> {
            repository.loadPaymentTypes()
        }
    }
    
    public class MakePaymentTransaction: MakePaymentTransactionProtocol {
        private let repository: BalanceRepositoryProtocol
        public init(repository: BalanceRepositoryProtocol) {
            self.repository = repository
        }
        public func execute(model: CardPaymentRequest, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<CardPaymentData, ValidationErrors>, Never> {
            repository.makePaymentTransaction(model: model)
        }
    }
    
    public class MakePaymentTransactionOTP: MakePaymentTransactionOTPProtocol {
        private let repository: BalanceRepositoryProtocol
        
        public init(repository: BalanceRepositoryProtocol) {
            self.repository = repository
        }
        
        public func execute(model: ProvideOTPPaymentRequest, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<CardPaymentData, ValidationErrors>, Never> {
            repository.makePaymentTransactionOtp(model: model)
        }
    }
    
    public class GenerateLink: GenerateLinkProtocol {
        private let repository: BalanceRepositoryProtocol
        
        public init(repository: BalanceRepositoryProtocol) {
            self.repository = repository
            
        }
        
        public func execute(model: FillPaymentRequest, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<LinkPaymentData, ValidationErrors>, Never> {
            repository.generateLink()
        }
    }
}
