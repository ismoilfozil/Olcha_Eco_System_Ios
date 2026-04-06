import UIKit
import OlchaUI
import Combine

public class BackVerificationCoordinator:  VerificationCoordinatorProtocol {
   
    
    public var bag: Set<AnyCancellable> = .init()
    public var picker: OlchaUI.MediaPicker?
    public var dismissedViewController: UIViewController?
    public var presentLastPage: PassthroughSubject<Bool, Never> = .init()
    public var navigationController: UINavigationController
    public var completion: (() -> Void)? = nil
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func pushPhonesVerification(withStatus: Bool) {
        let vc: PhonesVerificationPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.withStatus = withStatus
        vc.completion = popViewController
        navigationController.push(vc)
    }
    
    public func pushPassportVerification(withStatus: Bool) {
        let vc: PassportsVerificationPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.withStatus = withStatus
        vc.completion = popViewController
        navigationController.push(vc)
    }
  
    
    public func pushMyIdVerification() {
        let vc: MyIdPassportInfoPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.completion = popViewController
        navigationController.push(vc)
    }
    
    
    public func pushBankCardsPage(withStatus: Bool) {
        let vc: BankCardsVerificationPageProtocol = OlchaVerificationDIContainer.shared.resolve()
        vc.coordinator = self
        vc.withStatus = withStatus
        vc.completion = popViewController
        navigationController.push(vc)
    }
    
}

private extension BackVerificationCoordinator {
    func popViewController() {
        navigationController.pop()
    }
}
