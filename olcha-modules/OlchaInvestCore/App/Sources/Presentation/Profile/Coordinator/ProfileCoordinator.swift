//
//  ProfileCoordinator.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import Combine
import OlchaUI
import OlchaUtils
import OlchaCommon
import OlchaAuth
import OlchaPincode
import OlchaVerification
import OlchaBalance
import OlchaBilling

public protocol ProfileCoordinatorProtocol: Coordinator, VerificationCoordinatorProtocol, AddBillingCardCoordinatorProtocol {
    func selectBalance(balanceId: Int)
    
    func pushPersonalDataViewController()
    func pushSettingsViewController()
    func pushAboutViewController()
    func pushLanguageViewController()
    
    func pushSafety()
    
    func pushFillBalance(balanceFilled: PassthroughSubject<Void, Never>?, balance: BillingCollectionItem)
    func pushEditPincode()
    func presentEditPassword()
    func presentMenu()
}

public class ProfileCoordinator: InvestMainCoordinator, ProfileCoordinatorProtocol {
    
    public var bag: Set<AnyCancellable> = .init()
    public var picker: MediaPicker?
    public var dismissedViewController: UIViewController?
    public var presentLastPage: PassthroughSubject<Bool, Never> = .init()
    public var completion: (() -> Void)? = nil
    
    private let pincodeCoordinator: PincodeCoordinatorProtocol
    private let billingCoordinator: BillingCoordinatorProtocol
    
    
    public override init(navigationController: UINavigationController) {
        self.pincodeCoordinator = PincodeCoordinator(navigationController: navigationController, state: .edit)
        self.billingCoordinator = BillingDIContainer.shared.resolve(argument: navigationController)
        super.init(navigationController: navigationController)
    }
    
    deinit {
        print("ProfileCoordinator deinit")
    }
    
    public override func start() {
        let vc: ProfileViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc], animated: false)
    }
    
    public func selectBalance(balanceId: Int) {
        let vc: ProfileViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        vc.balanceId = balanceId
        navigationController.set([vc], animated: false)
    }
    
    public func pushPersonalDataViewController() {
        let vc: PersonalDataViewController = InvestDIContainer.shared.resolve()
        navigationController.push(vc)
    }

    public func pushSettingsViewController() {
        let vc: SettingsViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushAboutViewController() {
        let vc: AboutViewController = CommonDIContainer.shared.resolve()
        vc.setup(logo: .olchaAppLogo, url: Texts.appUrl.olchaUrl)
        navigationController.push(vc)
    }
    
    public func pushLanguageViewController() {
        let vc: LanguageViewController = CommonDIContainer.shared.resolve()
        navigationController.push(vc)
    }
    
    public func pushSafety() {
        let vc: SafetyViewController = InvestDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushEditPincode() {
        pincodeCoordinator.startEditPincodeFlow()
        pincodeCoordinator.completion = { [weak self] in
            guard let self = self else { return }
            navigationController.popViewController(to: SafetyViewController.self)
        }
    }
    
    public func pushPhonesVerification(withStatus: Bool) {
        let vc: PhonesVerificationPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.completion = { [weak self] in
            guard let self = self else { return }
            navigationController.pop()
        }
        navigationController.push(vc)
    }
    
    public func pushPassportVerification(withStatus: Bool) {
        let vc: PassportsVerificationPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.completion = { [weak self] in
            guard let self = self else { return }
            navigationController.pop()
        }
        navigationController.push(vc)
    }
    
    public func pushMyIdVerification(){
        let vc: MyIdPassportInfoPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.completion = { [weak self] in
            guard let self = self else { return }
            navigationController.pop()
        }
        navigationController.push(vc)
    }
    
    public func pushBankCardsPage(withStatus: Bool) {
        let vc: BankCardsVerificationPageProtocol = BillingDIContainer.shared.resolve()
        vc.coordinator = self
        (vc as? BillingCardsVerificationPage)?.addBillingCardCoordinator = self
        vc.completion = { [weak self] in
            guard let self = self else { return }
            navigationController.pop()
        }
        navigationController.push(vc)
    }
    
    public func presentAddBillingCard(filter: BillingPaymentFilter,
                                      loadCards: PassthroughSubject<Bool, Never>,
                                      creditVerificationObserver: (() -> Void)?) {
        let vc: AddBillingCardModalPage = BillingDIContainer.shared.resolve()
        vc.creditVerificationObserver = creditVerificationObserver
        vc.filter = filter
        vc.loadCards = loadCards
        navigationController.presentModally(vc)
    }
    
    public func presentEditPassword() {
        let vc: EditPasswordModalPage = AuthDIContainer.shared.resolve()
        navigationController.presentModally(vc)
    }
    
    public func pushFillBalance(balanceFilled: PassthroughSubject<Void, Never>?, balance: BillingCollectionItem) {
        let filter: BillingPaymentFilter = .init()
            .set(reflection: balance.balance?.billing_reflection_alias)
            .set(order_id: balance.balance?.id?.int)
            .set(order_currency: balance.currency)
            .set(payment_alias: balance.alias)
        
        billingCoordinator.pushBillingPayment(filter: filter, completion: nil)
    }
    
    public func presentMenu() {
        menuCoordinator.start()
    }
    
}
