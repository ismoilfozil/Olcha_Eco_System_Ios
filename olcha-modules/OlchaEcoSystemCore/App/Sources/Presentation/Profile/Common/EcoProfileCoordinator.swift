import UIKit
import OlchaUI
import OlchaUtils
import OlchaCommon
import OlchaMarketModule
import OlchaNasiyaModule
import OlchaInvestCore
import OlchaPayModule
import OlchaCommon
import OlchaCashback

public protocol EcoProfileCoordinatorProtocol: OlchaUI.Coordinator {
    func pushAuth(completion: (() -> Void)?)
    func pushNotification()
    func pushLanguage()
    func pushAbout()
    func pushSettings()
    func pushSafety()
    func pushCashback()
    func clickActionRouter(action: ClickAction)
}

public class EcoProfileCoordinator: EcoMainCoordinator, EcoProfileCoordinatorProtocol {
   
    public lazy var settingsCoordinator: SettingsCoordinatorProtocol = CommonDIContainer.shared.resolve(argument: navigationController)
    
    public override func start() {
        let vc: EcoProfileViewController = EcoDIContainer.shared.resolve()
        vc.coordinator = self
        vc.selectObserver = performClickAction
        navigationController.set([vc], animated: false)
    }
    
    public func pushAuth(completion: (() -> Void)?) {
        authCoordinator.pushAuth(isSet: false, completion: completion)
    }
    
    public func pushNotification() {
        let vc: NotificationViewController = CommonDIContainer.shared.resolve(argument: Organization.ecoSystem)
        vc.selectObserver = performClickAction
        navigationController.push(vc)
    }
    
    public func pushAbout() {
        let vc: AboutViewController = CommonDIContainer.shared.resolve()
        vc.setup(logo: .olchaAppLogo, url: Texts.appUrl.olchaUrl)
        navigationController.push(vc)
    }
    
    public func pushLanguage() {
        settingsCoordinator.pushLanguage()
    }
    
    public func pushSettings() {
        settingsCoordinator.start()
    }
    
    public func pushSafety() {
        commonCoordinator.pushSafety {
            EcoAppConfigurator.shared.appCoordinator?.logout()
        }
    }
    
    public func pushCashback() {
        ModuleGeneratorHelper.shared.generate(module: .cashback, appStarted: nil)
    }
   
    public func clickActionRouter(action: ClickAction) {
        clickActionCoordinator.clickActionRouter(action: action)
    }
}

private extension EcoProfileCoordinator {
    func performClickAction(_ action: ClickAction?) {
        guard let action else { return }
        clickActionCoordinator.clickActionRouter(action: action)
    }
}
