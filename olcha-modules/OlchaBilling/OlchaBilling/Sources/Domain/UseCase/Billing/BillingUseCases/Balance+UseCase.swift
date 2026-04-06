////
////  Billing+UseCase.swift
////  OlchaBilling
////
////  Created by Elbek Khasanov on 12/07/23.
////
//
//import Foundation
//import OlchaBankCards
//import OlchaUtils
//import Combine
//import OlchaCore
//
//extension BillingUseCase {
//    public class LoadBillingBalances: LoadBillingBalancesProtocol {
//        
//        private let repository: BankCardRepositoryProtocol
//        
//        public init(repository: BankCardRepositoryProtocol) {
//            self.repository = repository
//        }
//        
//        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingBalancesData, EmptyData>, Never> {
//            repository.loadEntities(filter: filter)
//        }
//     
//    }
//}
