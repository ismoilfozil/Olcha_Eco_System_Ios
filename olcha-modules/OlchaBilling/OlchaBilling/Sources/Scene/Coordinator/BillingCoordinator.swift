//
//  BillingCoordinator.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 03/07/23.
//

import UIKit
import OlchaBankCards
import Combine
import OlchaUI
import OlchaUtils

public protocol BillingCoordinatorProtocol: Coordinator {
    func pushBillingPayment(filter: BillingPaymentFilter, completion: (() -> Void)?)
    func pushSuccess()
    func presentAddBankCard(filter: BillingPaymentFilter, loadCards: PassthroughSubject<Bool, Never>?)
}

extension BillingCoordinatorProtocol {
    public func pushBillingPayment(filter: BillingPaymentFilter, completion: (() -> Void)? = nil) {
        self.pushBillingPayment(filter: filter, completion: completion)
    }
}

public class BillingCoordinator: BillingCoordinatorProtocol {
    public var navigationController: UINavigationController
    
    public var completion: (() -> Void)?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {}

    public func pushBillingPayment(filter: BillingPaymentFilter, completion: (() -> Void)?) {
        self.completion = completion
        let vc: BillingPaymentViewController = BillingDIContainer.shared.resolve()
        vc.coordinator = self
        vc.input.billingFilter = filter
        vc.setupData()
        navigationController.push(vc)
    }
    
    public func pushSuccess() {
        completion?()
        let vc: BillingSuccessViewController = BillingDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func presentAddBankCard(filter: BillingPaymentFilter, loadCards: PassthroughSubject<Bool, Never>?) {
        let vc: AddBillingCardModalPage = BillingDIContainer.shared.resolve()
        vc.filter = filter
        vc.loadCards = loadCards
        navigationController.presentModally(vc)
    }
}
