//
//  HomeCoordinator.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 09/02/23.
//

import Foundation
import UIKit
import OlchaCore
import Combine
import OlchaUI
public protocol PayHomeCoordinatorProtocol: Coordinator {
    
    func presentMyCardsList(addCardObserver: (() -> Void)?)
    func presentMyCardsList(makePaymentHelper: MakePaymentHelper)
    
    func pushNotificationsList()
    func pushDetailedNotification(_ notification: NotificationModel?)
    func pushNewsList()
    func pushDetailedNews(news: [NewsModel], currentIndex: Int, currentPage: Int)
    func pushPaymentPage(service: ServiceModel?)
    func pushPaymentType()
    func pushPaymentDetail(transaction: TransactionModel?)
    func pushMonitoring()
    
    func pushProviders(category: CategoryModel?)
    
    func pushQR()
    
    func pushAddNewCard(completed: (() -> Void)?)
    func pushSearch(categoryID: Int?)
    
    func pushProvider(provider: ProviderModel?)
    
    func pushSavedTransactionsList()
    func pushEditTransaction(id: Int?)
    
    func pushMakeTransaction(savedTransaction: SavedTransactionModel?)
    func pushMakeTransaction(makePaymentHelper: MakePaymentHelper)
    func pushPhoneMakeTransaction(phone: String)
    
    func pushAuth()
    func pushLanguageSettings()
}

public class PayHomeCoordinator: PayMainCoordinator, PayHomeCoordinatorProtocol {
    
    public let addCardCoordinator: AddCardCoordinatorProtocol
    
    public override init(navigationController: UINavigationController) {
        self.addCardCoordinator = AddCardCoordinator(navigationController: navigationController)
        super.init(navigationController: navigationController)
    }
    
    public override func start() {
        let vc: HomeViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc])
    }
    
    public func presentMyCardsList(addCardObserver: (() -> Void)?) {
        let vc: CardsListModalViewController = PayDIContainer.shared.resolve()
        
        vc.coordinator = self
        vc.addCardObserver = addCardObserver
        
        navigationController.presentModally(vc)
    }
    
    public func presentMyCardsList(makePaymentHelper: MakePaymentHelper) {
        let vc: CardsListModalViewController = PayDIContainer.shared.resolve()
        
        vc.coordinator = self
        vc.makePaymentHelper = makePaymentHelper
        vc.isSelectable = true
        navigationController.presentModally(vc)
    }
    
    public func pushNotificationsList() {
        let vc: NotificationsViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushDetailedNotification(_ notification: NotificationModel?) {
        let vc: DetailedNotificationViewController = PayDIContainer.shared.resolve()
        vc.notification = notification
        navigationController.presentModally(vc)
    }
    
    public func pushNewsList() {
        let vc: NewsListViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushDetailedNews(news: [NewsModel], currentIndex: Int, currentPage: Int) {
        let vc: DetailedNewsViewController = PayDIContainer.shared.resolve(arguments: currentIndex, currentPage)
        vc.news = news
        navigationController.push(vc)
    }
    
    public func pushPaymentPage(service: ServiceModel?) {
        paymentsCoordinator.pushMakeTransaction(
            makePaymentHelper: MakePaymentHelper().addService(service)
        )
    }
    
    public func pushPaymentType() {
    }
    
    public func pushSavedTransactionsList() {
        let vc: SavedTransactionsViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushPaymentDetail(transaction: TransactionModel?) {
        paymentsCoordinator.pushTransactionDetail(transaction: transaction)
    }
    
    public func pushMonitoring() {
        profileCoordinator.pushMonitoring()
    }
    
    public func pushQR() {
        paymentsCoordinator.pushQRPaymentCamera()
    }
    
    public func pushAddNewCard(completed: (() -> Void)?)  {
        addCardCoordinator.completed = completed
        addCardCoordinator.pushAddCard()
    }
    
    public func pushProviders(category: CategoryModel?) {
        paymentsCoordinator.pushProvidersList(category: category)
    }
    
    public func pushSearch(categoryID: Int?) {
        let vc: SearchViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        vc.categoryID = categoryID
        navigationController.push(vc)
    }
    
    public func pushProvider(provider: ProviderModel?) {
        paymentsCoordinator.pushProvider(provider: provider)
    }
    
    public func pushEditTransaction(id: Int?) {
        paymentsCoordinator.pushEditTransaction(id: id)
    }
    
    public func pushMakeTransaction(savedTransaction: SavedTransactionModel?) {
        paymentsCoordinator.pushMakeTransaction(savedTransaction: savedTransaction)
    }
    
    public func pushMakeTransaction(makePaymentHelper: MakePaymentHelper) {
        paymentsCoordinator.pushMakeTransaction(makePaymentHelper: makePaymentHelper)
    }
    
    public func pushPhoneMakeTransaction(phone: String) {
        paymentsCoordinator.pushPhoneMakeTransaction(phone: phone)
    }
    
    public func pushAuth() {
        authCoordinator.pushAuth(isSet: false) {}
    }
    
    public func pushLanguageSettings() {
        profileCoordinator.pushLanguage()
    }
}
