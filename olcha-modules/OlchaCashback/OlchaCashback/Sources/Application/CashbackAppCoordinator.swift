import UIKit
import OlchaUI
import OlchaAuth
import OlchaPincode

public protocol CashbackAppCoordinatorProtocol: AppCoordinatorProtocol {
    
}

public class CashbackAppCoordinator: CashbackAppCoordinatorProtocol {
    
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
        let vc: CashbackWebViewController = CashbackDIContainer.shared.resolve()
        navigationController.set([vc], animated: false)
    }
    
    public func presentAuth(completion: (() -> Void)?) {
        authCoordinator.pushAuth(isSet: false, completion: completion)
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
