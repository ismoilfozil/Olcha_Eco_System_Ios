//
//  BillingRepository.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 21/06/23.
//

import Foundation
import OlchaCore
import Combine
import OlchaUtils
import OlchaBankCards
import OlchaUI

public protocol BillingRepositoryProtocol {
    var api: BillingAPIProtocol { get set }
    func loadPaymentTypes(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentsData, EmptyData>, Never>
    func generateLink(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentData, EmptyData>, Never>
    func makePaymentOtp(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentData, EmptyData>, Never>
    func makePayment(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
    func loadEntities(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingEntitiesData , EmptyData>, Never>
    func loadCurrency(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingCurrencyData , EmptyData>, Never>
}

public class BillingRepository: BaseRepository, BillingRepositoryProtocol {
    private var bag = Set<AnyCancellable>()
    public var api: BillingAPIProtocol
    
    public init(manager: NetworkManagerProtocol,
                api: BillingAPIProtocol) {
        self.api = api
        super.init(manager: manager)
    }
    
    public func loadPaymentTypes(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentsData, EmptyData>, Never> {
        manager.request(api: api.payments(filter: filter))
    }
    
    public func generateLink(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentData, EmptyData>, Never> {
        manager.request(api: api.generateLink(filter: filter))
    }
    
    public func makePaymentOtp(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingPaymentData, EmptyData>, Never> {
        manager.request(api: api.makePaymentOtp(filter: filter))
    }
    
    public func makePayment(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        manager.request(api: api.makePayment(filter: filter))
    }
    
    public func loadEntities(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingEntitiesData , EmptyData>, Never> {
        manager.request(api: api.loadEntities(filter: filter))
    }
    
    public func loadCurrency(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BillingCurrencyData, EmptyData>, Never> {
        manager.request(api: api.loadCurrency(filter: filter), isCancellable: true)
//        return Future { promise in
//            promise(
//                .success(
//                    BaseResponse(status: .success,
//                                 error: nil,
//                                 response: BillingCurrencyData(rate: "11500", round: "up"),
//                                 code: 200,
//                                 errors: nil)
//                )
//            )
//        }.eraseToAnyPublisher()
    }
}
