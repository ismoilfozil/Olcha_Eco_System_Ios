////
////  BankCards+UseCase.swift
////  OlchaBilling
////
////  Created by Elbek Khasanov on 12/07/23.
////
//
//import Foundation
//import OlchaUtils
//import Combine
//import OlchaBankCards
//import OlchaCore
//
//extension BillingUseCase {
//    public class LoadBillingBankCards: LoadBankCardsProtocol {
//        
//        private var bag = Set<AnyCancellable>()
//        private let repository: BankCardRepositoryProtocol
//        
//        public init(repository: BankCardRepositoryProtocol) {
//            self.repository = repository
//        }
//        
//        public func execute(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BankCardsData, EmptyData>, Never> {
//            return Future { [weak self] promise in
//                guard let self = self else { return }
//                BillingPaymentTypesManager.shared.loadPaymentType(filter: filter) { data in
//                    self.repository.loadEntities(
//                        filter: filter.set(alias: data?.getBankCardApis().first?.alias)
//                    )
//                    .sink { (baseResponse: BaseResponse<BillingBankCardsData, EmptyData>) in
//                        promise(
//                            .success(
//                                .init(status: baseResponse.status,
//                                      error: baseResponse.error,
//                                      response: baseResponse.response?.map(min_amount: data?.getBankCardApis().first?.min_amount,
//                                                                           max_amount: data?.getBankCardApis().first?.max_amount),
//                                      code: baseResponse.code,
//                                      errors: baseResponse.errors))
//                        )
//                    }.store(in: &self.bag)
//                }
//            }.eraseToAnyPublisher()
//        }
//        
//        deinit {
//            bag.forEach { $0.cancel() }
//        }
//    }
//}
