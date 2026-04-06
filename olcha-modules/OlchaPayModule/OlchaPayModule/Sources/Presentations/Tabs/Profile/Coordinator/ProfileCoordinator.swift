//
//  SettingsCoordinator.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 14/02/23.
//

import UIKit
import Combine
import OlchaUI
import OlchaAuth
import OlchaPincode
import OlchaCommon

public protocol ProfileCoordinatorProtocol: Coordinator {
    var pincodeCoordinator: PincodeCoordinatorProtocol { get }
    func pushEditPincode()
    func presentMonitoringFilter()
    func pushAuth()
    func pushMonitoring()
    func pushPaymentDetail(transaction: TransactionModel?)
    func pushSupport()
    func pushSettings()
    func pushLanguage()
    func pushNotifications()
    func pushProfileData()
    
    func presentEditName(user: User?, observer: PassthroughSubject<Bool, Never>?)
    func presentEditPassword()
    func presentEditMail(user: User?, observer: PassthroughSubject<Bool, Never>?)
}

public class ProfileCoordinator: PayMainCoordinator, ProfileCoordinatorProtocol {
    public var pincodeCoordinator: PincodeCoordinatorProtocol
    
    public override init(navigationController: UINavigationController) {
        self.pincodeCoordinator = PincodeCoordinator(navigationController: navigationController, state: .edit)
        super.init(navigationController: navigationController)
    }
    
    public override func start() {
        let vc: ProfileViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc])
    }
    
    public func pushEditPincode() {
        pincodeCoordinator.startEditPincodeFlow()
        pincodeCoordinator.completion = { [weak self] in
            guard let self = self else { return }
            self.navigationController.popToRootViewController(animated: true)
        }
        pincodeCoordinator.logout = {
            PayAppConfigurator.shared.appCoordinator?.logout()
        }
    }
    
    public func presentMonitoringFilter() {
        let vc: MonitoringFilterViewController = PayDIContainer.shared.resolve()
        navigationController.presentModally(vc)
    }
    
    public func pushAuth() {
        authCoordinator.pushAuth(isSet: false, completion: nil)
    }
    
    public func pushMonitoring() {
        
    }
    
    public func pushPaymentDetail(transaction: TransactionModel?) {
        paymentsCoordinator.pushTransactionDetail(transaction: transaction)
    }
    
    public func pushSupport() {
        let vc: PrivacyViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushSettings() {
        let vc: SettingsViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushLanguage() {
        let vc: LanguageViewController = CommonDIContainer.shared.resolve()
        navigationController.push(vc)
    }
    
    public func pushProfileData() {
        let vc: ProfileDataViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func presentEditName(user: User?, observer: PassthroughSubject<Bool, Never>?) {
        let vc: EditNameModalPage = PayDIContainer.shared.resolve()
        vc.user = user
        vc.userUpdateObserver = observer
        navigationController.presentModally(vc)
    }
    
    public func presentEditPassword() {
        let vc: EditPasswordModalPage = AuthDIContainer.shared.resolve()
        navigationController.presentModally(vc)
    }
    
    public func presentEditMail(user: User?, observer: PassthroughSubject<Bool, Never>?) {
        let vc: EditMailModalPage = PayDIContainer.shared.resolve()
        vc.user = user
        vc.userUpdateObserver = observer
        navigationController.presentModally(vc)
    }
    
    public func pushNotifications() {
        payHomeCoordinator.pushNotificationsList()
    }
}
