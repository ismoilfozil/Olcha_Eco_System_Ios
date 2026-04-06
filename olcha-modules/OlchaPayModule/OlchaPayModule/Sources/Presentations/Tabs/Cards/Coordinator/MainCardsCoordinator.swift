//
//  MainCardsCoordinator.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 09/02/23.
//


import UIKit
import OlchaUI
public protocol MainCardsCoordinatorProtocol: Coordinator {
    func presentCardColor(observers: CardSettingsObserver, card: UserBankCardModel?)
    func presentCardName(observers: CardSettingsObserver, card: UserBankCardModel?)
    
    func pushAddNewCard(completed: @escaping (() -> Void) )
    func pushPaymentDetail(transaction: TransactionModel?)
    func pushMonitoring()
    
    func pushCardMonitoring(bankCard: UserBankCardModel?)
}

public class MainCardsCoordinator: PayMainCoordinator, MainCardsCoordinatorProtocol {
    
    public let addCardCoordinator: AddCardCoordinatorProtocol
    
    public override init(navigationController: UINavigationController) {
        addCardCoordinator = AddCardCoordinator(navigationController: navigationController)
        super.init(navigationController: navigationController)
    }
    
    public override func start() {
        let vc: MainCardsViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc])
    }
    
    public func presentCardColor(observers: CardSettingsObserver, card: UserBankCardModel?) {
        let vc: CardColorModalViewController = PayDIContainer.shared.resolve()
        vc.observers = observers
        vc.card = card
        navigationController.presentModally(vc)
    }
    
    public func presentCardName(observers: CardSettingsObserver, card: UserBankCardModel?) {
        let vc: CardNameModalViewController = PayDIContainer.shared.resolve()
        vc.observers = observers
        vc.card = card
        navigationController.presentModally(vc)
    }
    
    public func pushAddNewCard(completed: @escaping (() -> Void))  {
        addCardCoordinator.completed = completed
        addCardCoordinator.pushAddCard()
    }
    
    public func pushPaymentDetail(transaction: TransactionModel?) {
        paymentsCoordinator.pushTransactionDetail(transaction: transaction)
    }
    
    public func pushMonitoring() {
        profileCoordinator.pushMonitoring()
    }
    
    public func pushCardMonitoring(bankCard: UserBankCardModel?) {
        monitoringCoordinator.pushCardMonitoring(bankCard: bankCard)
    }
}

