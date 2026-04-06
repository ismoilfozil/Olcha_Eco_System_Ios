//
//  PackagesCoordinator.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaCommon
import OlchaUtils
import Combine

public protocol BasePackagesCoordinatorProtocol: Coordinator {
    var packageIdObserver: CurrentValueSubject<Int?, Never> { get }
    var termObserver: CurrentValueSubject<InvestmentModel?, Never> { get }
    var investAmountObserver: CurrentValueSubject<Double, Never> { get }
    func stopInvestSelection()
    func pushAmountViewController()
    func pushSelectTermViewController(packageId: Int, childPackageId: Int?)
}

public extension BasePackagesCoordinatorProtocol {
    func pushAmountViewController() {
        let vc: AmountViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    func pushSelectTermViewController(packageId: Int, childPackageId: Int? = nil) {
        let vc: SelectTermViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        vc.fillOutput(packageId: packageId, childPackageId: childPackageId)
        navigationController.push(vc)
    }
}

public protocol PackagesCoordinatorProtocol: BasePackagesCoordinatorProtocol {
    func selectHomeTab()
    func pushNotificationViewController()
    func pushPackagesDetailViewController(investmentId: Int)
    func pushInvestViewController()
    func presentMenu()
}

public class PackagesCoordinator: InvestMainCoordinator, PackagesCoordinatorProtocol {
    
    public var packageIdObserver = CurrentValueSubject<Int?, Never>(nil)
    public var termObserver = CurrentValueSubject<InvestmentModel?, Never>(nil)
    public var investAmountObserver = CurrentValueSubject<Double, Never>(0)
    
    public override func start() {
        let vc: PackagesViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc], animated: false)
    }
    
    public func selectHomeTab() {
        navigationController.tabBarController?.selectedIndex = InvestTab.home
    }
    
    public func stopInvestSelection() {
        pushInvestViewController()
    }
    
    public func pushNotificationViewController() {
        let vc: NotificationViewController = CommonDIContainer.shared.resolve(argument: Organization.invest)
        navigationController.push(vc)
    }
    
    public func pushPackagesDetailViewController(investmentId: Int) {
        let vc: PackagesDetailViewController = InvestDIContainer.shared.resolve()
        vc.output.investmentId = investmentId
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushInvestViewController() {
        let coordinator = InvestCoordinator(navigationController: navigationController)
        coordinator.packageIdObserver = packageIdObserver
        coordinator.termObserver = termObserver
        coordinator.investAmountObserver = investAmountObserver
        coordinator.pushInvestViewController()
    }
    
    public func popToInvestViewController() {
        navigationController.popViewController(to: InvestViewController.self)
    }
    
    public func presentMenu() {
        menuCoordinator.start()
    }
    
}
