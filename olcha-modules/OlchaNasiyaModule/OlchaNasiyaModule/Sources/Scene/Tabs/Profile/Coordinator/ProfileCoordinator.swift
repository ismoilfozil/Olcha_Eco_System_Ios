//
//  NasiyaProfileCoordinator.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 22/05/23.
//


import UIKit
import OlchaUI
import OlchaVerification
import OlchaPincode
import OlchaCommon
import OlchaAuth
import OlchaUtils

public protocol ProfileCoordinatorProtocol: Coordinator {
    var completion: (() -> Void)? { get set }
    func pushProfileData()
    func pushBankCards()
    func pushPassportData()
    func pushPhones()
    func pushSafety()
    func pushEditPincode()
    func presentEditPassword()
    func pushSettings()
    func pushLanguage()
    func pushAboutApp()
    func pushFaqs()
    func pushVerificationFlow()
    func presentMenu()
}

public class ProfileCoordinator: NasiyaMainCoordinator, ProfileCoordinatorProtocol {
    
    public var completion: (() -> Void)? = nil
    private var nasiyaVerificationCoordinator: VerificationCoordinatorProtocol
    private let pincodeCoordinator: PincodeCoordinatorProtocol
    
    public override init(navigationController: UINavigationController) {
        self.nasiyaVerificationCoordinator = OlchaVerificationDIContainer.shared.resolve(
            name: NasiyaVerificationCoordinator.classIdentifier,
            argument: navigationController
        )
        self.pincodeCoordinator = PincodeCoordinator(navigationController: navigationController, state: .edit)
        super.init(navigationController: navigationController)
    }
    
    public override func start() {
        let vc: NasiyaProfileViewController = NasiyaDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc])
    }
    
    public func pushProfileData() {
        let vc: ProfileDataViewController = NasiyaDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushBankCards() {
        nasiyaVerificationCoordinator.pushBankCardsPage(withStatus: true)
    }
    
    public func pushPassportData() {
        nasiyaVerificationCoordinator.pushPassportVerification(withStatus: true)
    }
    
    public func pushPhones() {
        nasiyaVerificationCoordinator.pushPhonesVerification(withStatus: true)
    }
    
    public func pushSafety() {
        let vc: SafetyViewController = NasiyaDIContainer.shared.resolve()
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
    
    public func presentEditPassword() {
        let vc: EditPasswordModalPage = AuthDIContainer.shared.resolve()
        navigationController.presentModally(vc)
    }
    
    public func pushSettings() {
        let vc: SettingsViewController = NasiyaDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushLanguage() {
        let vc: LanguageViewController = CommonDIContainer.shared.resolve()
        navigationController.push(vc)
    }
    
    public func pushAboutApp() {
        let vc: AboutViewController = CommonDIContainer.shared.resolve()
        vc.setup(logo: .olchaAppLogo, url: Texts.appUrl.olchaUrl)
        navigationController.push(vc)
    }
    
    public func pushFaqs() {
        let vc: NasiyaFAQViewController = NasiyaDIContainer.shared.resolve()
        navigationController.push(vc)
    }
    
    public func pushVerificationFlow() {
        nasiyaVerificationCoordinator = OlchaVerificationDIContainer.shared.resolve(
            name: NasiyaVerificationCoordinator.classIdentifier,
            argument: navigationController
        )
        nasiyaVerificationCoordinator.completion = completion
        nasiyaVerificationCoordinator.start()
    }
    
    public func presentMenu() {
        menuCoordinator.start()
    }
}
