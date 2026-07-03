//
//  CartCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/09/22.
//

import OlchaUI
import UIKit
import Combine
import OlchaVerification
import OlchaUtils
import OlchaBalance

public protocol CartCoordinatorProtocol: Coordinator {
    
    func pushAddLocationMap(observers: CartObservers)
    func pushAddLocationMap(address: UserAddress?, observers: CartObservers)
    func presentCreditBuy(products: [ProductModel], balanceViewModel: BalanceViewModel, observers: CartObservers?)
    func pushCreditCartPage(data: CreditOrder)
    func pushProductPage(product: ProductModel?)
    func pushPayment(paymentURL: String)
    func presentCartVerification(verificationFinished: (() -> Void)?)
    func presentCartVariation(product: ProductModel?,
                              productType: ProductType)
    func presentOpenProductVariation(product: ProductModel?,
                                     productType: ProductType,
                                     completion: ((ProductModel?) -> Void)?)
    func changeCartTab()
    func pushFillBalance(observers: CartObservers?)
    func anorbankVerify(verifyObserver: PassthroughSubject<Bool, Never>, orderID: Int?)
    func presentSimpleBuy(product: ProductModel?, type: SimpleBuyModalPage.BuyType)
    
    func pushMyOrdersList()
    func presentImportProducts(products: [ProductModel], completion: (() -> Void)?)
    func pushAuth(completion: (() -> Void)?)
    func presentLocationsModalPage(locationsViewModel: LocationsPageViewModel?,
                                   observers: CartObservers?)
    
    func presentReceiverModalPage(observers: CartObservers?)
    func presentShippingModalPage(text: String?)
    func presentGetCostModalPage(observers: CartObservers?)
    func presentBuyTypeModalPage(observers: CartObservers?, balanceViewModel: BalanceViewModel?, checkoutViewModel: CheckoutViewModel?)
    func presentPaymentsModalPage(observers: CartObservers?, checkoutViewModel: CheckoutViewModel?)
    func presentCouponModalPage(observers: CartObservers?, checkoutViewModel: CheckoutViewModel?)
    func presentBonusModalPage(observers: CartObservers?, completion: (() -> Void)?)
    func presentEmptyBonusModalPage()
    func presentCartProducts(observers: CartObservers?)
    func presentCreditRequirementModal(continueAction: (() -> Void)?)
    func presentExternalInstallmentRequirementModal(provider: ExternalInstallmentProvider?,
                                                    continueAction: (() -> Void)?)
    func pushWebPage(urlString: String, title: String?)

    func startVerificationByCurrentStep(step: VerificationStatusStep?)
}

public class CartCoordinator: OlchaMainCoordinator, CartCoordinatorProtocol {
    
    public override func start() {
        
        let vc = CartPage()
        vc.userCart.type = .cash
        vc.coordinator = self
        navigationController.set([vc])
        
    }
    
    public func pushAddLocationMap(observers: CartObservers) {
        profileCoordinator.cartObservers = observers
        profileCoordinator.pushAddLocationMap(address: nil, completion: nil)
    }
    
    public func pushAddLocationMap(address: UserAddress?, observers: CartObservers) {
        profileCoordinator.cartObservers = observers
        profileCoordinator.pushAddLocationMap(address: address, completion: nil)
    }
    
    public func presentCreditBuy(products: [ProductModel], balanceViewModel: BalanceViewModel, observers: CartObservers?) {
        let vc = CartCreditModalPage()
        vc.products = products
        vc.observers = observers
        vc.balanceViewModel = balanceViewModel
        navigationController.presentModally(vc)
    }
    
    public func presentReceiverModalPage(observers: CartObservers?) {
        let vc = ReceiverDataModalPage()
        vc.coordinator = self
        vc.observers = observers
        vc.setupOptionalActions()
        navigationController.presentModally(vc)
    }
    
    public func pushCreditCartPage(data: CreditOrder) {
        authCoordinator.pushAuth(isSet: false) { [weak self] in
            guard let self = self else { return }
            let vc = UserCartPage()
            vc.coordinator = self
            vc.type = .credit
            vc.initialCreditOrder = data
            vc.observers.selectedBuyType = .credit
            vc.observers.credit = data
            self.navigationController.push(vc)
        }
        
    }
    
    public func pushProductPage(product: ProductModel?) {
        productCoordinator.pushProductPage(product: product)
    }
    
    public func presentCartVerification(verificationFinished: (() -> Void)?) {
        verificationCoordinator.presentCartVerification(verificationFinished: verificationFinished)
    }
    
    public func presentCartVariation(product: ProductModel?,
                                     productType: ProductType) {
        dismissPresentedViewController()
        let vc = CartVariationPage()
        vc.productType = productType
        vc.openType = .cart
        vc.coordinator = self
        vc.product = product
        navigationController.presentModally(vc)
    }
    
    public func presentOpenProductVariation(product: ProductModel?,
                                            productType: ProductType,
                                            completion: ((ProductModel?) -> Void)?) {
        dismissPresentedViewController()
        let vc = CartVariationPage()
        vc.productType = productType
        vc.openType = .comeBack
        vc.product = product
        vc.completion = completion
        vc.coordinator = self
        navigationController.presentModally(vc)
    }
    
    
    public func anorbankVerify(verifyObserver: PassthroughSubject<Bool, Never>, orderID: Int?) {
        let vc = AnorbankCardVerifyPage()
//        vc.verifyObserver = verifyObserver
//        vc.orderID = orderID
        navigationController.presentModally(vc)
    }
    
    func dismissPresentedViewController() {
        if navigationController.presentedViewController is ModalPageType {
            navigationController.dismiss()
        }
    }
    
    public func changeCartTab() {
        navigationController.dismiss(animated: true)
        authCoordinator.pushAuth(isSet: false) { [weak self] in
            guard let self = self else { return }
            if self.navigationController.tabBarController?.selectedIndex == OlchaTab.cart {
                self.navigationController.popToRootViewController(animated: true)
            } else {
                self.navigationController.tabBarController?.selectedIndex = OlchaTab.cart
            }
        }
    }
    
    public func pushFillBalance(observers: CartObservers?) {
        balanceCoordinator.balanceFilled = observers?.action.balanceFilled
        balanceCoordinator.creditVerificationObserver = {
            OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
        }
        balanceCoordinator.start()
    }
    
    public func presentSimpleBuy(product: ProductModel?, type: SimpleBuyModalPage.BuyType) {
        productCoordinator.presentSimpleBuy(product: product, type: type)
    }
    
    public func pushPayment(paymentURL: String) {
        profileCoordinator.pushOrderPay(urlString: paymentURL)
    }
    
    public func pushMyOrdersList() {
        profileCoordinator.pushMyOrdersPage()
    }
    
    public func presentImportProducts(products: [ProductModel], completion: (() -> Void)?) {
        let vc = CartImportModalPage()
        vc.input.products = products
        vc.completion = completion
        vc.coordinator = self
        vc.setup()
        navigationController.presentModally(vc)
    }
    
    public func pushAuth(completion: (() -> Void)?) {
        authCoordinator.pushAuth(isSet: false, completion: completion)
    }
    
    public func presentLocationsModalPage(
        locationsViewModel: LocationsPageViewModel?,
        observers: CartObservers?
    ) {
        let vc = CartLocationsModalPage()
        vc.coordinator = self
        vc.observers = observers
        vc.locationsViewModel = locationsViewModel
        vc.setupOptionalActions()
        navigationController.presentModally(vc)
    }
    
    public func presentShippingModalPage(text: String?) {
        let vc = ShippingDataModalPage()
        vc.text = text 
        navigationController.presentModally(vc)
    }
    
    public func presentGetCostModalPage(observers: CartObservers?) {
        let vc = GetCostModalPage()
        vc.observers = observers
        vc.setupOptionalActions()
        navigationController.presentModally(vc)
    }
    
    public func presentBuyTypeModalPage(observers: CartObservers?, balanceViewModel: BalanceViewModel?, checkoutViewModel: CheckoutViewModel?) {
        let vc = BuyTypeModalPage()
        vc.observers = observers
        vc.balanceViewModel = balanceViewModel
        vc.checkoutViewModel = checkoutViewModel
        vc.setupOptionalActions()
        navigationController.presentModally(vc)
    }
    
    public func presentPaymentsModalPage(observers: CartObservers?, checkoutViewModel: CheckoutViewModel?) {
        let vc = PaymentsModalPage()
        vc.observers = observers
        vc.checkoutViewModel = checkoutViewModel
        vc.setupOptionalActions()
        navigationController.presentModally(vc)
    }
    
    public func presentCouponModalPage(observers: CartObservers?, checkoutViewModel: CheckoutViewModel?) {
        let vc = CouponModalPage()
        vc.observers = observers
        vc.checkoutViewModel = checkoutViewModel
        vc.setupOptionalActions()
        navigationController.presentModally(vc)
    }
    
    public func presentBonusModalPage(observers: CartObservers?, completion: (() -> Void)?) {
        let vc = BonusModalPage()
        vc.completion = completion
        vc.observers = observers
        vc.setupOptionalActions()
        navigationController.presentModally(vc)
    }
 
    public func presentEmptyBonusModalPage() {
        let vc = EmptyBonusModalPage()
        navigationController.presentModally(vc)
    }
    
    public func presentCartProducts(observers: CartObservers?) {
        let vc = CartProductsModalPage()
        vc.observers = observers
        navigationController.presentModally(vc)
    }

    public func presentCreditRequirementModal(continueAction: (() -> Void)?) {
        let vc = CreditRequirementModalPage()
        vc.continueAction = continueAction
        vc.coordinator = self
        navigationController.presentModally(vc)
    }

    public func presentExternalInstallmentRequirementModal(provider: ExternalInstallmentProvider?,
                                                           continueAction: (() -> Void)?) {
        let vc = ExternalInstallmentRequirementModalPage()
        vc.provider = provider
        vc.continueAction = continueAction
        navigationController.presentModally(vc)
    }

    public func pushWebPage(urlString: String, title: String? = nil) {
        let vc = WebPage()
        vc.urlString = urlString
        vc.headerTitle = title
        navigationController.push(vc)
    }

    public func startVerificationByCurrentStep(step: VerificationStatusStep?) {
        if let step = step {
            self.verificationCoordinator.pushVerification(step: step)
        } else {
            self.verificationCoordinator.start()
        }
    }
}
