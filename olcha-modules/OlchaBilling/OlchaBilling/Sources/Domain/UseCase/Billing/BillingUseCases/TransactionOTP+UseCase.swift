////
////  Transaction+UseCase.swift
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
//    public class MakeBillingPaymentOTPTransactionProtocol: OlchaBalance.MakePaymentTransactionOTPProtocol {
//
//        private var bag = Set<AnyCancellable>()
//        private let repository: BillingRepositoryProtocol
//        private let loadBillingBalancesUseCase: LoadBalanceProtocol
//        
//        public init(repository: BillingRepositoryProtocol,
//                    loadBillingBalancesUseCase: LoadBalanceProtocol) {
//            self.repository = repository
//            self.loadBillingBalancesUseCase = loadBillingBalancesUseCase
//        }
//        
//        public func execute(model: OlchaBalance.ProvideOTPPaymentRequest, filter: BillingPaymentFilter) -> AnyPublisher<OlchaCore.BaseResponse<OlchaBalance.CardPaymentData, OlchaCore.EmptyData>, Never> {
//            return Future { [weak self] promise in
//                guard let self = self else { return }
//                BillingPaymentTypesManager.shared.loadPaymentType(
//                    filter: filter.set(reflection: .order)
//                ) { data in
//                    self.loadBillingBalancesUseCase.execute(
//                        filter: filter.set(alias: data?.getBalances().first?.alias)
//                    )
//                    .sink {  baseResponse in
//                        self.repository.makePayment(
//                            filter: filter
//                                          .set(alias: data?.getBankCardApis().first?.alias)
//                                          .set(order_id: baseResponse.response?.balances?.first?.id)
//                                          .set(otp: model.otp)
//                                          .set(transaction_id: model.transaction.string)
//                                          .set(reflection: .balance)
//                        )
//                        .sink { baseResponse in
//                            promise(
//                                .success(
//                                    BaseResponse(status: baseResponse.status,
//                                                 error: baseResponse.error,
//                                                 response: CardPaymentData(payment_id: 0),
//                                                 code: baseResponse.code,
//                                                 errors: baseResponse.errors)
//                                )
//                            )
//                        }.store(in: &self.bag)
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
