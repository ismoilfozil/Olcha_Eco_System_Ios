//
//  VerificationCoordinatorProtocol.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 22/05/23.
//

import UIKit
import Combine
import OlchaUI
import OlchaBankCards
public protocol VerificationCoordinatorProtocol: Coordinator {
    var bag: Set<AnyCancellable> { get set}
    var picker: MediaPicker? { get set}
    var dismissedViewController: UIViewController? { get set}
    var presentLastPage: PassthroughSubject<Bool, Never> { get set}
    var completion: (() -> Void)? { get set }
    func pushPhonesVerification(withStatus: Bool)
    func pushPassportVerification(withStatus: Bool)
    func pushMyIdVerification()
    func pushBankCardsPage(withStatus: Bool)
    func presentVerifyTimer(timeInterval: Int)
    func presentSuccess()
    func presentDeny()
    func presentAddCardPage(loadCards: PassthroughSubject<Bool, Never>?)
    func mediaPicker(type: MediaPicker.MediaType,
                     sourceType: UIImagePickerController.SourceType,
                     imageObserver: PassthroughSubject<UIImage?, Never>?,
                     saveLastPage: Bool)
    
    func presentCartVerification(verificationFinished: (() -> Void)?)
    
    func pushVerification(step: VerificationStatusStep)
    func setupObserver()
}
extension VerificationCoordinatorProtocol {
   
    public func start() {
        pushMyIdVerification()
    }
    
    public func pushVerification(step: VerificationStatusStep) {
        
        switch step {
        case .identification:
            checkMyIdContains() ? popToPassport() : start()
        case .phones:
            checkPhonesContains() ? popToPhones() : pushPhonesVerification(withStatus: true)
        case .bankCard:
            checkBankCardsContains() ? popToBankCards() : pushBankCardsPage(withStatus: true)
        }
    }
    
    public func mediaPicker(type: MediaPicker.MediaType,
                            sourceType: UIImagePickerController.SourceType,
                            imageObserver: PassthroughSubject<UIImage?, Never>?,
                            saveLastPage: Bool) {
        
        if saveLastPage {
            dismissedViewController = navigationController.presentedViewController
        }
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
        picker = MediaPicker()
        picker?.presentLastPage = presentLastPage
        picker?.mediaType = type
        picker?.selectedImageObserver = imageObserver
        picker?.present(navigationController: navigationController, sourceType: sourceType)
    }
    
    public func presentCartVerification(verificationFinished: (() -> Void)?) {
        
        let vc: CartVerificationPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.verificationFinished = verificationFinished
        navigationController.presentModally(vc)
        
    }
    
    
    public func presentAddCardPage(loadCards: PassthroughSubject<Bool, Never>?) {
        
        let vc: AddCardModalPage = BankCardsDIContainer.shared.resolve()
        vc.creditVerificationObserver = {
            
            OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
            
        }
        
        vc.loadCards = loadCards
        navigationController.presentModally(vc)
        
    }
    
    public func presentVerifyTimer(timeInterval: Int) {
        let vc: VerifyTimerViewController = OlchaVerificationDIContainer.shared.resolve()
        vc.modalPresentationStyle = .overFullScreen
        vc.coordinator = self
        vc.timerInterval = timeInterval
        navigationController.present(vc, animated: true)
    }
    
    public func presentSuccess() {
        let vc: SuccessViewController = OlchaVerificationDIContainer.shared.resolve()
        vc.modalPresentationStyle = .overFullScreen
        vc.setCloseButton { [weak self] in
            self?.navigationController.dismiss()
        }
        navigationController.present(vc, animated: true)
    }
    
    public func presentDeny() {
        let vc: DenyViewController = OlchaVerificationDIContainer.shared.resolve()
        vc.modalPresentationStyle = .overFullScreen
        vc.setCloseButton { [weak self] in
            self?.navigationController.dismiss()
        }
        navigationController.present(vc, animated: true)
    }
    
    public func setupObserver() {
        presentLastPage.sink { [weak self] canShow in
            
            guard canShow,
                  let self = self,
                  let vc = self.dismissedViewController else { return }
            self.navigationController.presentModally(vc)
            
        }.store(in: &bag)
    }
}

extension VerificationCoordinatorProtocol {


    public func checkMyIdContains() -> Bool {
        return navigationController.viewControllers.contains(where: { $0 is MyIdPassportInfoPageProtocol })
    }
    
    public func checkPassportContains() -> Bool {
        return navigationController.viewControllers.contains(where: { $0 is PassportsVerificationPageProtocol })
    }
    
    public func checkPhonesContains() -> Bool {
        return navigationController.viewControllers.contains(where: { $0 is PhonesVerificationPageProtocol })
    }
    
    public func checkBankCardsContains() -> Bool {
        return navigationController.viewControllers.contains(where: { $0 is BankCardsVerificationPageProtocol })
    }
    
    func popToMyId(animated: Bool = true) {
        if let vc = navigationController.viewControllers.last(where: { $0 is MyIdPassportInfoPageProtocol }) {
            navigationController.popToViewController(vc, animated: animated)
        }
    }
    
    func popToPassport(animated: Bool = true) {
        if let vc = navigationController.viewControllers.last(where: { $0 is PassportsVerificationPageProtocol }) {
            navigationController.popToViewController(vc, animated: animated)
        }
    }
    
    func popToPhones(animated: Bool = true) {
        if let vc = navigationController.viewControllers.last(where: { $0 is PhonesVerificationPageProtocol }) {
            navigationController.popToViewController(vc, animated: animated)
        }
    }
    
    func popToBankCards(animated: Bool = true) {
        if let vc = navigationController.viewControllers.last(where: { $0 is BankCardsVerificationPageProtocol }) {
            navigationController.popToViewController(vc, animated: animated)
        }
    }
}

