//
//  HomeCoordinator.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import Combine
import OlchaUI
import OlchaBilling
import OlchaUtils
import OlchaCommon
import OlchaVerification

public protocol NasiyaHomeCoordinatorProtocol: Coordinator {

    func pushFillBalance(balance: BillingCollectionItem, completion: (() -> Void)?)

    func requestLimit()
    func selectLimitCard()

    func pushNotifications()
    func pushInstallment(installment: InstallmentModel?)
    func presentMenu()
    func pushVerificationFlow()
}

public class NasiyaHomeCoordinator: NasiyaMainCoordinator, NasiyaHomeCoordinatorProtocol {
    
    private var verificationCoordinator: VerificationCoordinatorProtocol?
    
    public override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
        
    public override func start() {
        let vc: NasiyaHomeViewController = NasiyaDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc])
    }
    

    public func pushFillBalance(balance: BillingCollectionItem, completion: (() -> Void)?) {
        let filter = BillingPaymentFilter()
            .set(payment_alias: balance.alias)
            .set(order_id: balance.balance?.id?.int)
            .set(reflection: balance.balance?.billing_reflection_alias)
            .set(order_currency: balance.currency)
        billingCoordinator.pushBillingPayment(
            filter: filter, completion: completion
        )
    }

    public func requestLimit() {
        let vc: NasiyaHomeViewController = NasiyaDIContainer.shared.resolve()
        vc.coordinator = self
        vc.homeViewModel.requestLimit()
        navigationController.set([vc], animated: false)
    }
    
    public func selectLimitCard() {
        let vc: NasiyaHomeViewController = NasiyaDIContainer.shared.resolve()
        vc.selectLimit()
        vc.coordinator = self
        navigationController.set([vc], animated: false)
    }

    public func pushNotifications() {
        let vc: NotificationViewController = CommonDIContainer.shared.resolve(argument: Organization.nasiya)
        vc.selectObserver = performClickAction
        navigationController.push(vc)
    }
    
    public func pushInstallment(installment: InstallmentModel?) {
        installmentsCoordinator.pushInstallment(installment: installment, shouldPay: false)
    }
    
    public func presentMenu() {
        menuCoordinator.start()
    }
    
    public func pushVerificationFlow() {
        self.verificationCoordinator = OlchaVerificationDIContainer.shared.resolve(
            name: NasiyaVerificationCoordinator.classIdentifier,
            argument: navigationController
        )
        verificationCoordinator?.start()
        verificationCoordinator?.completion = { [weak self] in
            guard let self else { return }
            navigationController.popToRootViewController(animated: true)
            performClickAction(NasiyaClickAction.profile)
        }
    }
}

private extension NasiyaHomeCoordinator {
    func performClickAction(_ action: ClickAction) {
        switch action {
        case let nasiyaAction as NasiyaClickAction:
            let appCoordinator: NasiyaAppCoordinatorProtocol? = ModuleGeneratorHelper.shared.getModuleCoordinator(module: .nasiya)
            appCoordinator?.clickActionRouter(action: nasiyaAction)
        default: break
        }
    }
}
