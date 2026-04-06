//
//  ProfileCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 17/08/22.
//

import UIKit
import Combine
import SwiftUI
import OlchaUI
import OlchaVerification
import OlchaAuth
public protocol ProfileCoordinatorProtocol: Coordinator {
    var cartObservers: CartObservers? { get set }
    var returnOrderCoordinator: ReturnOrderCoordinatorProtocol? { get set }
    
    func selectBalance()
    func selectBonus()
    func pushVerificationPage1()
    func pushVerification(step:VerificationStatusStep)
    func pushCompare(product: ProductModel?, animated: Bool)
    func pushProduct(product: ProductModel?)
    func pushProductList(category: CategoryModel?)
    
    func pushLocationsList(animated: Bool)
    func pushAddLocationMap(address: UserAddress?, completion: (() -> Void)?)
    func pushUsersFullLocationPage(address: UserAddress?, completion: (() -> Void)?)
    func finishedSaving(address: UserAddress?)
    
    func pushFavourites(animated: Bool)
    func setFavourites()
    func pushNotifications()
    
    func pushWebCheck(urlString: String)
    
    func pushProfileDataPage(user: User?)
    func pushBankCardsPage()
    func presentEditName(user: User?, userUpdateObserver: PassthroughSubject<Bool, Never>)
    func presentEditMail(user: User?, userUpdateObserver: PassthroughSubject<Bool, Never>)
    func presentPassword()
    
    func pushAuth(completion: (() -> Void)?)
    
    func pushMyOrdersPage(animated: Bool)
    func pushReturnOrder(animated: Bool)
    
    func presentOrdersStep(steps: [OrderStatus])
    func presentDeliveryCode(code: String, orderId: Int?)
    func presentCancelCause(causeObserver: @escaping ((String) -> Void))
    func pushSearchOrderPage()
    
    func pushMyReviews(type: ReviewType, animated: Bool)
    
    func pushSettingsPage()
    func pushLanguagesPage()
    
    func pushOrder(order: Order?)
    func pushFoundOrder(order: Order?)
    
    func pushOrderPay(urlString: String)

    func presentCartVariation(product: ProductModel?,
                              productType: ProductType)
    
    func anorbankVerify(verifyObserver: PassthroughSubject<Bool, Never>, orderID: Int?)
    
    func pushAddReview(product: ProductModel?)
    func pushEditReview(review: Comment)
    func pushReviewMedia(review: Comment?, index: Int)
    func pushReviewReplies(review: Comment?, product: ProductModel?)
    func pushFAQReplies(question: Comment?, product: ProductModel?)
    func pushRamazanTaqvim()
    func pushOneIdGuide()
    func pushFillBalance(balanceFilled: PassthroughSubject<Void, Never>?)
}

public extension ProfileCoordinatorProtocol {
    func pushMyOrdersPage(animated: Bool = true) {
        let vc: MyOrdersPage = OlchaDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc, animated: animated)
    }
    
    func pushMyReviews(type: ReviewType, animated: Bool = true) {
        let vc: MyReviewsPage = OlchaDIContainer.shared.resolve()
        vc.currentType = type
        vc.coordinator = self
        navigationController.push(vc, animated: animated)
    }
    
    func pushCompare(product: ProductModel?, animated: Bool = true) {
        let vc: ComparePage = OlchaDIContainer.shared.resolve()
        vc.product = product
        vc.coordinator = self
        navigationController.push(vc, animated: animated)
    }
    
    func pushLocationsList(animated: Bool = true) {
        let vc: LocationsListPage = OlchaDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc, animated: animated)
    }
    
    func pushReturnOrder(animated: Bool = true) {
        returnOrderCoordinator = ReturnOrderCoordinator(navigationController: navigationController)
        returnOrderCoordinator?.start(animated: animated)
    }
}

public class ProfileCoordinator: OlchaMainCoordinator, ProfileCoordinatorProtocol {
    public var returnOrderCoordinator: ReturnOrderCoordinatorProtocol?
    public weak var cartObservers: CartObservers?
    
    public override func start() {
        let vc: ProfilePage = OlchaDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc])
    }
    
    public func selectBalance() {
        let vc: ProfilePage = OlchaDIContainer.shared.resolve()
        vc.selectItem = .balance
        vc.coordinator = self
        navigationController.set([vc], animated: false)
    }
    
    public func selectBonus() {
        let vc: ProfilePage = OlchaDIContainer.shared.resolve()
        vc.selectItem = .bonus
        vc.coordinator = self
        navigationController.set([vc], animated: false)
    }
    
    public func pushVerificationPage1() {
        verificationCoordinator.start()
    }
    
    public func pushVerification(step:VerificationStatusStep){
        verificationCoordinator.pushVerification(step: step)
    }
    
    public func pushProduct(product: ProductModel?) {
        catalogCoordinator.pushProductPage(product: product)
    }
    
    public func pushProductList(category: CategoryModel?) {
        catalogCoordinator.pushProductsListPage(category: category,
                                                 brand: nil,
                                                 catalogStack: [category].compactMap { $0 })
    }
    
    ///map stopped
    public func pushAddLocationMap(address: UserAddress?, completion: (() -> Void)?) {
        pushUsersFullLocationPage(address: address, completion: completion)
//        let vc = MapPage()
//        vc.coordinator = self
//        vc.address = address ?? .init()
//        navigationController.push(vc)
    }
    
    public func pushUsersFullLocationPage(address: UserAddress?, completion: (() -> Void)?) {
        let vc: UserFullLocationPage = OlchaDIContainer.shared.resolve()
        vc.completion = completion
        vc.coordinator = self
        vc.address = address
        navigationController.push(vc)
    }
    
    public func finishedSaving(address: UserAddress?) {
//        navigationController.popToRootViewController(animated: true)
        
        if let cartObservers = cartObservers {
            cartObservers.selectedAddress = address
            cartObservers.action.addressSelected.send()
            navigationController.popViewController(to: CartPage.self)
        } else {
            navigationController.pop()
        }
    }
    public func pushFavourites(animated: Bool) {
        let vc: FavouritesPage = OlchaDIContainer.shared.resolve()
        vc.coordinator = self
        self.navigationController.push(vc, animated: animated)
    }
    
    public func setFavourites() {
        let vc: FavouritesPage = OlchaDIContainer.shared.resolve()
        vc.isTabPage = true
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushProfileDataPage(user: User?) {
        let vc: ProfileDataPage = OlchaDIContainer.shared.resolve()
        vc.user = user
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushBankCardsPage() {
        verificationCoordinator.pushBankCardsPage(withStatus: false)
    }
    
    public func presentEditName(user: User?, userUpdateObserver: PassthroughSubject<Bool, Never>) {
        let vc: EditNameModalPage = OlchaDIContainer.shared.resolve()
        vc.user = user
        vc.userUpdateObserver = userUpdateObserver
        navigationController.presentModally(vc)
    }
    
    public func presentEditMail(user: User?, userUpdateObserver: PassthroughSubject<Bool, Never>) {
        let vc: EditMailModalPage = OlchaDIContainer.shared.resolve()
        vc.user = user
        vc.userUpdateObserver = userUpdateObserver
        navigationController.presentModally(vc)
    }
    
    public func pushAuth(completion: (() -> Void)?) {
        authCoordinator.pushAuth(isSet: false, completion: completion)
    }
    
    public func presentPassword() {
        let vc: EditPasswordModalPage = AuthDIContainer.shared.resolve()
        navigationController.presentModally(vc)
    }
    
    public func pushNotifications() {
        let vc: NotificationsPage = OlchaDIContainer.shared.resolve()
        navigationController.push(vc)
    }
    
    public func pushSearchOrderPage() {
        let vc: SearchOrderPage = OlchaDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func presentCancelCause(causeObserver: @escaping ((String) -> Void)) {
        let vc: OrderCancelPage = OlchaDIContainer.shared.resolve()
        vc.causeObserver = causeObserver
        navigationController.presentModally(vc)
    }
    
    public func presentOrdersStep(steps: [OrderStatus]) {
        let vc: OrdersStepModalPage = OlchaDIContainer.shared.resolve()
        vc.steps = steps
        navigationController.presentModally(vc)
    }

    public func presentDeliveryCode(code: String, orderId: Int?) {
        let vc: DeliveryCodeModalPage = OlchaDIContainer.shared.resolve()
        vc.deliveryCode = code
        vc.orderId = orderId
        navigationController.presentModally(vc)
    }
    
    public func pushSettingsPage() {
        let vc: SettingsPage = OlchaDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushLanguagesPage() {
        let vc: LanguagePage = OlchaDIContainer.shared.resolve()
        navigationController.push(vc)
    }
    
    public func pushOrder(order: Order?) {
        authCoordinator.pushAuth(isSet: false) { [weak self] in
            guard let self = self else { return }
            let vc = OrderPage()
            vc.coordinator = self
            vc.order = order
            self.navigationController.push(vc)
        }
    }
    
    public func pushFoundOrder(order: Order?) {
        let vc: FoundOrderPage = OlchaDIContainer.shared.resolve()
        vc.coordinator = self
        vc.order = order
        navigationController.push(vc)
    }
    
    public func pushOrderPay(urlString: String) {
        Funcs.openSafari(urlString: urlString)
//        let vc = WebPage()
//        vc.urlString = urlString
//        navigationController.push(vc)
    }
    
    public func pushWebCheck(urlString: String) {
        let vc: WebPage = OlchaDIContainer.shared.resolve()
        vc.urlString = urlString
        navigationController.push(vc)
    }
    
    public func presentCartVariation(product: ProductModel?,
                                     productType: ProductType) {
        cartCoordinator.presentCartVariation(product: product,
                                             productType: productType)
    }
    
    public func anorbankVerify(verifyObserver: PassthroughSubject<Bool, Never>, orderID: Int?) {
        let vc = AnorbankCardVerifyPage()
//        vc.orderID = orderID
//        vc.verifyObserver = verifyObserver
        navigationController.presentModally(vc)
    }
    
    public func pushAddReview(product: ProductModel?) {
        productCoordinator.pushAddReview(product: product)
    }
    
    public func pushEditReview(review: Comment) {
        productCoordinator.pushEditReview(review: review)
    }
    
    public func pushReviewMedia(review: Comment?, index: Int) {
        reviewCoordinator.pushReviewMedia(review: review, index: index)
    }
    
    public func pushReviewReplies(review: Comment?, product: ProductModel?) {
        reviewCoordinator.pushReviewReplies(review: review, product: product)
    }
    
    public func pushFAQReplies(question: Comment?, product: ProductModel?) {
        reviewCoordinator.pushFAQReplies(question: question, product: product)
    }
    
    public func pushRamazanTaqvim() {
        let vc: RamazanTimePage = OlchaDIContainer.shared.resolve()
        navigationController.push(vc)
    }

    public func pushOneIdGuide() {
        let vc: WebPage = OlchaDIContainer.shared.resolve()
        vc.urlString = "https://olcha.uz/oneid-guide"
        vc.headerTitle = "credit_requirement_guide".localized()
        navigationController.push(vc)
    }
    
    public func pushFillBalance(balanceFilled: PassthroughSubject<Void, Never>?) {
        balanceCoordinator.balanceFilled = balanceFilled
        balanceCoordinator.creditVerificationObserver = {
            OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
        }
        balanceCoordinator.start()
    }
}
