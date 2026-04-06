//
//  PaymentsCoordinator.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 11/02/23.
//


import UIKit
import Combine
import OlchaUI
public protocol PaymentsCoordinatorProtocol: Coordinator {
    func pushProvidersList(category: CategoryModel?)

    func pushPaymentFinish(transaction: TransactionModel?)
    func pushTransactionDetail(transaction: TransactionModel?)
    func pushSaveTransaction(transaction: TransactionModel?)
    func pushEditTransaction(id: Int?)
    func pushSaveTransactionFinished()
    
    func pushQRPaymentCamera()
    func pushQRPayment(url: String?)
    
    func presentMyBankCards(makePaymentHelper: MakePaymentHelper)
    
    func pushProvider(provider: ProviderModel?)
    func pushProvider(providerId: Int)
    func pushSearch(categoryID: Int?)
    
    func pushMakeTransaction(savedTransaction: SavedTransactionModel?)
    func pushMakeTransaction(detailedTransaction: TransactionModel?)
    
    func pushMakeTransaction(makePaymentHelper: MakePaymentHelper)
    func pushPhoneMakeTransaction(phone: String)
    func pushVerifyPayment(verifyData: TransactionOtpData?, makePaymentHelper: MakePaymentHelper)
    func finishPayment()
    
    func pushInvoice(transaction: TransactionModel?)
}

public class PaymentsCoordinator: PayMainCoordinator, PaymentsCoordinatorProtocol {
    
    public override func start() {
        let vc: CategoriesViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc])
    }
    
    /*
        let vc: PaymentsGroupViewController = DIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc])
    */
    
    public func pushProvidersList(category: CategoryModel?) {
        let vc: ProvidersListViewController = PayDIContainer.shared.resolve()
        vc.category = category
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushPaymentFinish(transaction: TransactionModel?) {
        let vc: PaymentFinishViewController = PayDIContainer.shared.resolve()
        vc.transaction = transaction
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushTransactionDetail(transaction: TransactionModel?) {
        let vc: DetailedTransactionViewController = PayDIContainer.shared.resolve()
        vc.transaction = transaction
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushSaveTransaction(transaction: TransactionModel?) {
        let vc: SaveTransactionViewController = PayDIContainer.shared.resolve()
        vc.transaction = transaction
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushEditTransaction(id: Int?) {
        let vc: EditTransactionViewController = PayDIContainer.shared.resolve()
        vc.id = id
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushSaveTransactionFinished() {
        let vc: SaveTransactionFinishViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushQRPaymentCamera() {
        
        CameraManager.checkPermission { [weak self] isAllowed in
            guard let self = self else { return }
            if isAllowed {
                self.presentCamera()
            }
        }
        
    }
    
    private func presentCamera() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let vc: QRCameraViewController = PayDIContainer.shared.resolve()
            vc.coordinator = self
            self.navigationController.push(vc)
        }
    }
    
    public func pushQRPayment(url: String?) {
        let vc: QRPaymentModalViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        vc.qrURL = url
        navigationController.presentModally(vc)
    }
    
    public func presentMyBankCards(makePaymentHelper: MakePaymentHelper) {
        payHomeCoordinator.presentMyCardsList(makePaymentHelper: makePaymentHelper)
    }
    
    public func pushProvider(provider: ProviderModel?) {
        let count = provider?.service?.count ?? 0
        
        if (count == 1) {
            pushMakeTransaction(
                makePaymentHelper: .init()
                                   .addProvider(provider)
                                   .addService(provider?.service?.first)
            )
        } else if (count > 1) {
            pushServicesList(provider: provider)
        }
    }
    
    public func pushProvider(providerId: Int) {
        let vc: ServicesListViewController = PayDIContainer.shared.resolve()
        vc.providerId = providerId
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushServicesList(provider: ProviderModel?) {
        let vc: ServicesListViewController = PayDIContainer.shared.resolve()
        vc.provider = provider
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushSearch(categoryID: Int?) {
        payHomeCoordinator.pushSearch(categoryID: categoryID)
    }
    
    public func pushMakeTransaction(savedTransaction: SavedTransactionModel?) {
        let vc: PaymentViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        vc.paymentHelper.configure(savedTransaction: savedTransaction)
        navigationController.push(vc)
    }
    
    public func pushMakeTransaction(makePaymentHelper: MakePaymentHelper) {
        guard (makePaymentHelper.service?.isDisabled() ?? false) == false else { return }
        let vc: PaymentViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        vc.paymentHelper = makePaymentHelper
        navigationController.push(vc)
    }
    
    public func pushPhoneMakeTransaction(phone: String) {
        let vc: PhonePaymentViewController = PayDIContainer.shared.resolve()
        vc.phone = phone
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushMakeTransaction(detailedTransaction: TransactionModel?) {
        let vc: PaymentViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        vc.paymentHelper.configure(transaction: detailedTransaction)
        navigationController.push(vc)
    }
    
    public func pushVerifyPayment(verifyData: TransactionOtpData?, makePaymentHelper: MakePaymentHelper) {
        let vc: PaymentOtpViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        vc.input.paymentHelper = makePaymentHelper
        vc.input.verifyOtpData = verifyData
        vc.setupData()
        navigationController.push(vc)
    }
    
    public func finishPayment() {
        navigationController.popToMainTab(mainTabIndex: PayTab.home)
    }
    
    public func pushInvoice(transaction: TransactionModel?) {
        let vc: PDFinvoiceViewController = PayDIContainer.shared.resolve(argument: transaction)
        navigationController.push(vc)
    }
}
