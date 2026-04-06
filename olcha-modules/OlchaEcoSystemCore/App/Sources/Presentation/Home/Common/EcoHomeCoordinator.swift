import UIKit
import OlchaUI
import OlchaUtils
import OlchaCommon
import OlchaAuth
import OlchaNasiyaModule
import OlchaInvestCore
import OlchaMarketModule
import OlchaCore

public protocol EcoHomeCoordinatorProtocol: OlchaUI.Coordinator {
    func pushSayohat()
    func pushNotification()
    func pushSearchViewController()
    func clickActionRouter(action: ClickAction)
    func pushConfirmationScreen()
}

public class EcoHomeCoordinator: EcoMainCoordinator, EcoHomeCoordinatorProtocol {
    
    public override func start() {
        let vc: EcoHomeViewController = EcoDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.set([vc], animated: false)
    }
    
    public func pushSayohat() {
        let vc: EcoSayohatViewController = EcoDIContainer.shared.resolve()
        navigationController.push(vc)
    }
    
    public func pushNotification() {
        let vc: NotificationViewController = CommonDIContainer.shared.resolve(argument: Organization.ecoSystem)
        vc.selectObserver = clickActionRouter
        navigationController.push(vc)
    }
    
    public func pushSearchViewController() {
        searchCoordinator.pushSearchViewController()
    }
    
    public func clickActionRouter(action: ClickAction) {
        clickActionCoordinator.clickActionRouter(action: action)
    }

    public func pushConfirmationScreen() {
        guard let userId = AuthGlobalDefaults.user.id else {
            print("Error: User ID not found")
            return
        }

        let viewModel: EcoOrderConfirmationViewModel = EcoDIContainer.shared.resolve(argument: userId)
        let vc = EcoOrderConfirmationViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.push(vc)
    }
}
