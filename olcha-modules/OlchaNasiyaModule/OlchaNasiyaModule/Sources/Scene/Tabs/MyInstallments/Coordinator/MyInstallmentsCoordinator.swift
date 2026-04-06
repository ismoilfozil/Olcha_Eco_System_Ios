//
//  MyApplicationsCoordinator.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 15/05/23.
//

import UIKit
import OlchaUI
import OlchaBilling
import OlchaUtils

public protocol MyInstallmentsCoordinatorProtocol: Coordinator {
    func pushInstallment(installment: InstallmentModel?, shouldPay: Bool)
    func presentInstallmentStatus(filters: InstallmentFilter)
    func pushNotifications()
    func pushFaqs()
    func presentMenu()
    func pushBillingPayment(filter: BillingPaymentFilter)
}

public class MyInstallmentsCoordinator: NasiyaMainCoordinator, MyInstallmentsCoordinatorProtocol {
        
    public override func start() {
        let vc: MyInstallmentsViewController = NasiyaDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc])
    }
    
    public func pushInstallment(installment: InstallmentModel?, shouldPay: Bool = false) {
        let vc: MyInstallmentViewController = NasiyaDIContainer.shared.resolve()
        vc.input.installment = installment
        vc.coordinator = self
        vc.output.shouldPay = shouldPay
        navigationController.push(vc)
    }
    
    public func presentInstallmentStatus(filters: InstallmentFilter) {
        let vc: InstallmentSortModal = NasiyaDIContainer.shared.resolve()
        vc.output.filters = filters
        vc.setup()
        navigationController.presentModally(vc)
    }
    
    public func pushNotifications() {
        nasiyaHomeCoordinator.pushNotifications()
    }
    
    public func pushFaqs() {
        profileCoordinator.pushFaqs()
    }
    
    public func presentMenu() {
        menuCoordinator.start()
    }
    
    public func pushBillingPayment(filter: BillingPaymentFilter) {
        billingCoordinator.pushBillingPayment(filter: filter)
    }
}
