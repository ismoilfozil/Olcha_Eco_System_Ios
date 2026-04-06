//
//  InvestHomeCoordinator.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import Combine
import OlchaCommon
import OlchaBilling
import OlchaUtils

public protocol InvestHomeCoordinatorProtocol: Coordinator {
    var pauseReasonObserver: PassthroughSubject<String, Never>? { get set }
    func showPopUpViewController(title: String?, description: String?)
    func pushNotificationViewController()
    func pushContractViewController(contractId: Int)
    func presentInvestDetailModal()
    func pushInvestProfitViewController(contractId: Int)
    func pushInvestViewController()
    func pushReinvestViewController(contractId: Int, reflection: String, currency: String)
    func presentContractPauseReasonModalViewController()
    func presentMenu()
}

public class InvestHomeCoordinator: InvestMainCoordinator, InvestHomeCoordinatorProtocol {
    
    public weak var pauseReasonObserver: PassthroughSubject<String, Never>?
    
    private let billingCoordinator: BillingCoordinatorProtocol
    
    public override init(navigationController: UINavigationController) {
        self.billingCoordinator = BillingDIContainer.shared.resolve(argument: navigationController)
        super.init(navigationController: navigationController)
    }
    
    public override func start() {
        let vc: InvestHomeViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc], animated: false)
    }
    
    public func showPopUpViewController(title: String?, description: String?) {
        let vc: InvestHomeViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        vc.showPopUpViewController(title: title, description: description)
        navigationController.set([vc], animated: false)
    }
    
    public func pushNotificationViewController() {
        let vc: NotificationViewController = CommonDIContainer.shared.resolve(argument: Organization.invest)
        vc.selectObserver = performClickAction
        navigationController.push(vc)
    }
    
    public func pushContractViewController(contractId: Int) {
        let vc: ContractViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        vc.contractId = contractId
        navigationController.push(vc)
    }
    
    public func presentContractPauseReasonModalViewController() {
        let vc: ContractPauseReasonModalViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.presentModally(vc)
    }
    
    public func presentInvestDetailModal() {
        let vc: InvestHomeModalViewController = InvestDIContainer.shared.resolve()
        navigationController.presentModally(vc)
    }
    
    public func pushInvestProfitViewController(contractId: Int) {
        let investCoordinator: ProfitCoordinatorProtocol = ProfitCoordinator(navigationController: navigationController)
        investCoordinator.pushInvestProfitViewController(contractId: contractId)
    }
    
    public func pushInvestViewController() {
        let coordinator: InvestCoordinatorProtocol = InvestCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
    public func pushReinvestViewController(contractId: Int, reflection: String, currency: String) {
        let filter: BillingPaymentFilter = .init()
            .set(reflection: reflection)
            .set(order_id: contractId)
            .set(order_currency: currency)
            .payAllButton(hidden: true)
        
        billingCoordinator.pushBillingPayment(filter: filter, completion: nil)
    }
    
    public func presentMenu() {
        menuCoordinator.start()
    }
    
}

private extension InvestHomeCoordinator {
    func performClickAction(_ action: ClickAction) {
        switch action {
        case let investAction as InvestClickAction:
            let appCoordinator: InvestAppCoordinatorProtocol? = ModuleGeneratorHelper.shared.getModuleCoordinator(module: .invest)
            appCoordinator?.clickActionRouter(action: investAction)
        default: break
        }
    }
}
