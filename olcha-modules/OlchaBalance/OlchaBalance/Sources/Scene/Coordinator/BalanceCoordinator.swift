//
//  BalansCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/11/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaUtils
import OlchaBankCards
public protocol BalanceCoordinatorProtocol: Coordinator {
    var navigationController: UINavigationController { get set }
    
    var balanceFilled: PassthroughSubject<Void, Never>? { get set }
    
    var creditVerificationObserver: (() -> Void)? { get set }
    
    var lastPage: UIViewController.Type? { get set }
    func pushBalanceCards()
    func pushPaymentFill(payment: Payments?)
    func presentAddCardPage(loadCards: PassthroughSubject<Bool, Never>?)
    
    func pushEnterPayment(card: BankCard)
    
    func pushPayPage(url: String)
    func dismissToRoot()
}

public class BalanceCoordinator: BalanceCoordinatorProtocol {
    public var navigationController: UINavigationController
    
    public weak var balanceFilled: PassthroughSubject<Void, Never>?
    
    public var lastPage: UIViewController.Type?
    
    public var creditVerificationObserver: (() -> Void)?
    ///DI Name it means that, which balance should load?
    ///Billing balance, Olcha balance and etc.
    public var diName: String?
    
    public init(navigationController: UINavigationController, diName: String? = nil) {
        self.navigationController = navigationController
        self.diName = diName
    }
    
    public func start() {
        lastPage = BalanceFillPage.self
        let vc: BalanceFillPage = BalanceDIContainer.shared.resolve(argument: diName)
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushBalanceCards() {
        let vc: BalanceCardsPage = BalanceDIContainer.shared.resolve(argument: diName)
        vc.creditVerificationObserver = creditVerificationObserver
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func presentAddCardPage(loadCards: PassthroughSubject<Bool, Never>?) {
        let vc: AddCardModalPage = BankCardsDIContainer.shared.resolve(argument: diName)
        vc.creditVerificationObserver = creditVerificationObserver
        vc.loadCards = loadCards
        navigationController.presentModally(vc)
    }
    
    public func pushEnterPayment(card: BankCard) {
        let vc: EnterPaymentCardPage = BalanceDIContainer.shared.resolve(argument: diName)
        vc.coordinator = self
        vc.bankCard = card
        navigationController.push(vc)
    }
    
    public func pushPaymentFill(payment: Payments?) {
        let vc: EnterPaymentPage = BalanceDIContainer.shared.resolve(argument: diName)
        vc.coordinator = self
        vc.payment = payment
        navigationController.push(vc)
    }
    
    public func pushPayPage(url: String) {
        let vc: BalanceWebPage = BalanceDIContainer.shared.resolve(argument: diName)
        vc.coordinator = self
        vc.urlString = url
        navigationController.push(vc)
    }
    
    public func dismissToRoot() {
        self.balanceFilled?.send()
        guard let lastPage = lastPage else { return }
        navigationController.popLastViewController(to: lastPage)
    }
}
