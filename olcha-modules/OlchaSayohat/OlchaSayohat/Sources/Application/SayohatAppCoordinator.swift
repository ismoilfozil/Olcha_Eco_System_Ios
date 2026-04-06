import UIKit
import OlchaUI
import OlchaAuth
import OlchaPincode

public protocol SayohatAppCoordinatorProtocol: AppCoordinatorProtocol {
    
}

public class SayohatAppCoordinator: SayohatAppCoordinatorProtocol {
    
    public var navigationController: UINavigationController
    public var authCoordinator: AuthCoordinatorProtocol
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.authCoordinator = AuthDIContainer.shared.resolve(argument: navigationController)
    }
    
    public func presentPincode(completion: (() -> Void)?, logout: (() -> Void)?) {
        completion?()
    }
    
    public func presentTabController(completion: (() -> Void)?) {
        let vc: SayohatWebViewController = SayohatDIContainer.shared.resolve()
        navigationController.set([vc], animated: false)
    }
    
    public func presentAuth(completion: (() -> Void)?) {
        completion?()
    }
    
    public func startSplash(completion: (() -> Void)?) {
        completion?()
    }
    
    public func start(appStarted: (() -> Void)?) {
        startApp(appStarted: appStarted)
    }
    
    public func startApp(appStarted: (() -> Void)?) {
        appFlow(state: .onboarding, appStarted: appStarted, isParent: false)
    }
    
    public func logout() {
        AuthGlobalDefaults.logout()
        PincodeGlobalDefaults.session.logout()
        presentTabController(completion: nil)
    }
    
    public func getPincodeState() -> AppStateFlow {
        PincodeGlobalDefaults.session.isInitialPincode() ? .initialPincode : .pincode
    }
    
}
