//
//  AddCardCoordinator.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 19/02/23.
//

import UIKit
import Combine
import OlchaUI
public protocol AddCardCoordinatorProtocol: Coordinator {
    var completed: (() -> Void)? { get set }
    
    func pushOnboardingAddCard(isSet: Bool)
    func pushAddCard()
    func pushVerifyCode(cardModel: CardModel?)
    func pushCardDetail()
    func pushScannerPage(cardModel: CardModel, delegate: ScannerManagerDelegate)
}

public class AddCardCoordinator: PayMainCoordinator, AddCardCoordinatorProtocol {
    
    lazy var manager = ScannerManager(navigationController: navigationController)
    
    public var completed: (() -> Void)?
    
    public func pushOnboardingAddCard(isSet: Bool = true) {
        let vc: OnboardingViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        if isSet {
            navigationController.set([vc])
        } else {
            navigationController.push(vc)
        }
    }
    
    public func pushAddCard() {
        let vc: AddCardViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushScannerPage(cardModel: CardModel, delegate: ScannerManagerDelegate) {
        manager.delegate = delegate
        manager.pushScanner(cardModel: cardModel)
    }
    
    public func pushVerifyCode(cardModel: CardModel?) {
        let vc: AddCardVerifyViewController = PayDIContainer.shared.resolve()
        vc.cardModel = cardModel
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushCardDetail() {
        let vc: AddCardFinishViewController = PayDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
}
