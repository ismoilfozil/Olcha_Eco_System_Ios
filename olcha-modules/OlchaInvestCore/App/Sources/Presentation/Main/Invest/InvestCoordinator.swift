//
//  InvestCoordinator.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 25/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import Combine
import OlchaBilling
import OlchaUtils

public protocol InvestCoordinatorProtocol: BasePackagesCoordinatorProtocol {
    func stop()
    func pushInvestViewController()
    func pushSelectPackageViewController()
    func pushBillingPaymentViewController(contractId: Int, reflection: String, values: (min: Int?, max: Int?, amount: Int?))
    func pushCardViewController(contractName: String, investorId: Int, investmentId: Int, startInvest: Double)
    func pushAddCardViewController()
    func presentPackagesDetailViewController(investmentId: Int)
    func presentSuccessViewController(completion: (() -> Void)?)
    func popToInvestCardViewController()
    func popToInvestViewController()
}

public class InvestCoordinator: InvestMainCoordinator, InvestCoordinatorProtocol {
    public var packageIdObserver = CurrentValueSubject<Int?, Never>(nil)
    public var termObserver = CurrentValueSubject<InvestmentModel?, Never>(nil)
    public var investAmountObserver = CurrentValueSubject<Double, Never>(0)
    
    private let billingCoordinator: BillingCoordinatorProtocol
    
    public override init(navigationController: UINavigationController) {
        self.billingCoordinator = BillingDIContainer.shared.resolve(argument: navigationController)

        super.init(navigationController: navigationController)
    }
    
    deinit {
        print("InvestCoordinator deinit")
    }
    
    public override func start() {
        let vc: InvestViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func stop() {
        navigationController.popToRoot(mainTabIndex: InvestTab.home)
    }
    
    public func stopInvestSelection() {
        popToInvestViewController()
    }
    
    public func pushInvestViewController() {
        let vc: InvestViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushSelectPackageViewController() {
        let vc: SelectPackageViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushBillingPaymentViewController(contractId: Int, reflection: String, values: (min: Int?, max: Int?, amount: Int?)) {
        let filter: BillingPaymentFilter = .init()
            .set(reflection: reflection)
            .set(min_value: values.min)
            .set(max_value: values.max)
            .set(amount: values.amount)
            .set(order_id: contractId)
            .payAllButton(hidden: true)
            .amountField(disabled: true)
        
        billingCoordinator.pushBillingPayment(filter: filter, completion: nil)
    }
    
    public func pushCardViewController(contractName: String, investorId: Int, investmentId: Int, startInvest: Double) {
//        let coordinator: BillingCoordinatorProtocol = BillingDIContainer.shared.resolve(argument: navigationController)
//        let filter: BillingPaymentFilter = .init()
//            .set(amount: startInvest.int)
//            .set(reflection: "st_olcha_invest_balance_reflection")
//            .set(order_currency: <#T##String?#>)
//            .set(order_id: <#T##Int?#>)
//            .set(max_value: <#T##Int?#>)
        
//        coordinator.pushBillingPayment(filter: filter, completion: nil)
        let vc: CardViewController = InvestDIContainer.shared.resolve()
        vc.investCoordinator = self
        vc.mode = .fill
        vc.fillOutput(contractName: contractName, investorId: investorId, investmentId: investmentId, startInvest: startInvest)
        navigationController.push(vc)
    }
    
    public func pushAddCardViewController() {
        let vc: InvestAddCardViewController = InvestDIContainer.shared.resolve()
        vc.investorCoordinator = self
        navigationController.push(vc)
    }
    
    public func presentPackagesDetailViewController(investmentId: Int) {
        let vc: PackagesDetailViewController = InvestDIContainer.shared.resolve()
        vc.output.investmentId = investmentId
        vc.setInvestButtonHidden()
        navigationController.present(vc, animated: true)
    }
    
    public func presentSuccessViewController(completion: (() -> Void)?) {
        let vc: SuccessViewController = InvestDIContainer.shared.resolve()
        vc.modalPresentationStyle = .overFullScreen
        vc.closeObserver = { [weak self] in
            guard let self else { return }
            navigationController.dismiss(animated: true, completion: completion)
        }
        navigationController.present(vc, animated: true)
    }
    
    public func popToInvestCardViewController() {
        navigationController.popViewController(to: CardViewController.self)
    }
    
    public func popToInvestViewController() {
        navigationController.popViewController(to: InvestViewController.self)
    }
    
}
