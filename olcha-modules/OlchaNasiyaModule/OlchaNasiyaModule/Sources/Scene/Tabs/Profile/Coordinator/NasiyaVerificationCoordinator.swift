//
//  NasiyaVerificationCoordinator.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 22/05/23.
//

import UIKit
import OlchaUI
import Combine
import OlchaVerification
import OlchaBilling
import OlchaUtils
import OlchaAuth

public class NasiyaVerificationCoordinator:  VerificationCoordinatorProtocol, AddBillingCardCoordinatorProtocol {
    public var bag: Set<AnyCancellable> = .init()
    
    public var picker: OlchaUI.MediaPicker?
    
    public var dismissedViewController: UIViewController?
    
    public var presentLastPage: PassthroughSubject<Bool, Never> = .init()
    
    public var navigationController: UINavigationController
    
    public var isVerified: Bool {
        VerificationGlobalDefaults.settings.getVerificationType(userId: AuthGlobalDefaults.user.id) == .approved && AuthGlobalDefaults.user.isVerified.orFalse
    }
    
    public var completion: (() -> Void)? = nil
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func pushPhonesVerification(withStatus: Bool) {
        let vc: PhonesVerificationPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.withStatus = withStatus
        vc.completion = { [weak self] in
            guard let self = self else { return }
            isVerified ? navigationController.pop() : pushBankCardsPage(withStatus: true)
        }
        navigationController.push(vc)
    }
    
    public func pushMyIdVerification() {
        let vc: MyIdPassportInfoPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.completion = { [weak self] in
            guard let self = self else { return }
            isVerified ? navigationController.pop() : pushPhonesVerification(withStatus: true)
        }
        navigationController.push(vc)
    }
    
    public func pushPassportVerification(withStatus: Bool) {
        let vc: PassportsVerificationPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.withStatus = withStatus
        vc.completion = { [weak self] in
            guard let self = self else { return }
            isVerified ? navigationController.pop() : pushPhonesVerification(withStatus: true)
        }
        navigationController.push(vc)
    }
    
    public func pushBankCardsPage(withStatus: Bool) {
        let vc: BankCardsVerificationPageProtocol = BillingDIContainer.shared.resolve()
        vc.coordinator = self
        vc.withStatus = withStatus
        (vc as? BillingCardsVerificationPage)?.addBillingCardCoordinator = self
        vc.completion = { [weak self] in
            guard let self else { return }
            isVerified ? navigationController.pop() : presentNasiyaAlertView(type: .requested, completion: completion)
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
    
    public func presentNasiyaAlertView(type: NasiyaAlertType, completion: (() -> Void)? = nil) {
//        let vc = NasiyaAlertView()
//        vc.alertType = type
//        vc.modalPresentationStyle = .overFullScreen
//        vc.alertButtonObserver = completion
//        navigationController.present(vc, animated: false)
        navigationController.showNasiyaAlertView(message: nil, type: type, completion: completion)
    }
    
}
