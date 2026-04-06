//
//  File.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 15/07/23.
//

import Foundation
import OlchaUtils
import Combine

public class BillingPaymentTypesManager {
    private var bag = Set<AnyCancellable>()
    private let loadPaymentTypesUseCase: LoadPaymentTypesProtocol
    public static let shared = BillingPaymentTypesManager()
    
    private init() {
        loadPaymentTypesUseCase = BillingDIContainer.shared.resolve()
    }
    
    public func loadPaymentType(filter: BillingPaymentFilter, completion: ((BillingPaymentsData?) -> Void)?) {
        loadPaymentTypesUseCase.execute(filter: filter)
            .sink { baseResponse in
                completion?(baseResponse.response)
            }.store(in: &bag)
    }
    
    deinit {
        bag.forEach { $0.cancel() }
    }
}
