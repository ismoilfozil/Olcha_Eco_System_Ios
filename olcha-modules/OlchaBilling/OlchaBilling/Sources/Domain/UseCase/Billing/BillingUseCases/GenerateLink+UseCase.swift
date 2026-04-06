////
////  GenerateLink+UseCase.swift
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
//    public class GenerateBillingLink: OlchaBalance.GenerateLinkProtocol {
//        private var bag = Set<AnyCancellable>()
//        private let repository: BillingRepositoryProtocol
//
//        
//        public init(repository: BillingRepositoryProtocol) {
//            self.repository = repository
//        }
//        
//        public func execute(model: FillPaymentRequest, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<LinkPaymentData, EmptyData>, Never> {
//            return Future { [weak self] promise in
//                guard let self = self else { return }
//                self.repository.generateLink(
//                    filter: filter.set(alias: model.alias)
//                        .set(amount: model.amount)
//                )
//                .sink { baseResponse in
//                    promise(
//                        .success(.init(status: baseResponse.status,
//                                       error: baseResponse.error,
//                                       response: baseResponse.response?.map(),
//                                       code: baseResponse.code,
//                                       errors: baseResponse.errors))
//                    )
//                }.store(in: &self.bag)
//            }.eraseToAnyPublisher()
//        }
//        
//        deinit {
//            bag.forEach { $0.cancel() }
//        }
//    }
//}
