import UIKit
import OlchaUI

public protocol SettingsCoordinatorProtocol: Coordinator {
    func pushLanguage()
}

public class SettingsCoordinator: SettingsCoordinatorProtocol {
    
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc: SettingsViewController = CommonDIContainer.shared.resolve()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushLanguage() {
        let vc: LanguageViewController = CommonDIContainer.shared.resolve()
        navigationController.push(vc)
    }
    
}
