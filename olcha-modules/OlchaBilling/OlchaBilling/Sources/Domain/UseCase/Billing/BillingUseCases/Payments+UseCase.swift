////
////  Payments+UseCase.swift
////  OlchaBilling
////
////  Created by Elbek Khasanov on 12/07/23.
////
//
//import Foundation
//import OlchaUtils
//import OlchaCore
//import OlchaBankCards
//import Combine
//
//extension BillingUseCase {
//    public class LoadBillingPayments: OlchaBalance.LoadPaymentTypesProtocol {
//        
//        private let repository: BankCardRepositoryProtocol
//        
//        public init(repository: BankCardRepositoryProtocol) {
//            self.repository = repository
//        }
//        
//        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<PaymentTypeData, EmptyData>, Never> {
//            return Future { [weak self] promise in
//                guard let self = self else { return }
//                loadPaymentType(filter: filter) { baseResponse in
//                    
//                    var data = PaymentTypeData()
//                    data.payments = baseResponse.response?.getWebhooks().map { $0.map() }
//                    
//                    promise(
//                        .success(
//                            .init(status: baseResponse.status,
//                                  error: baseResponse.error,
//                                  response: data,
//                                  code: baseResponse.code,
//                                  errors: baseResponse.errors)
//                        )
//                    )
//                }
//            }.eraseToAnyPublisher()
//        }
//        
//        deinit {
//            bag.forEach { $0.cancel() }
//        }
//    }
//}
//
//
///// payment_entity_id => card_id
///// entity_id => balance_id
///// payment_system_alias => myuzcard
