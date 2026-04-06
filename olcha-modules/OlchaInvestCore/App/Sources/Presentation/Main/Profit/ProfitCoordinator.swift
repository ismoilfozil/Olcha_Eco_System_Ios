//
//  ProfitCoordinator.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public protocol ProfitCoordinatorProtocol: Coordinator {
    func stop()
    func pushInvestProfitViewController(contractId: Int)
    func pushInvestCardViewController(contractId: Int, investorId: Int, amount: Double)
    func pushAddCardViewController()
    func pushAutoWithdrawalViewController(contractId: Int, completion: (() -> Void)?)
    func presentSuccessViewController(completion: (() -> Void)?)
    func popToInvestCardViewController()
}

public class ProfitCoordinator: InvestMainCoordinator, ProfitCoordinatorProtocol {
    
    public func pushInvestProfitViewController(contractId: Int) {
        let vc: InvestProfitViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        vc.contractId = contractId
        navigationController.push(vc)
    }
    
    public func stop() {
        navigationController.popViewController(to: InvestHomeViewController.self)
    }
    
    public func pushInvestCardViewController(contractId: Int, investorId: Int, amount: Double) {
        let vc: CardViewController = InvestDIContainer.shared.resolve()
        vc.mode = .enroll
        vc.coordinator = self
        vc.fillOutput(contractId: contractId, investorId: investorId, amount: amount)
        navigationController.push(vc)
    }
    
    public func presentSuccessViewController(completion: (() -> Void)?) {
        let vc: SuccessViewController = InvestDIContainer.shared.resolve()
        vc.modalPresentationStyle = .overFullScreen
        vc.closeObserver = { [weak self] in
            self?.navigationController.dismiss()
            completion?()
        }
        navigationController.present(vc, animated: true)
    }
    
    public func pushAddCardViewController() {
        let vc: InvestAddCardViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushAutoWithdrawalViewController(contractId: Int, completion: (() -> Void)?) {
        let vc: AutoWithdrawalViewController = InvestDIContainer.shared.resolve()
        vc.completion = completion
        vc.coordinator = self
        vc.contractId = contractId
        navigationController.push(vc)
    }
    
    public func popToInvestCardViewController() {
        navigationController.popViewController(to: CardViewController.self)
    }
    
}
