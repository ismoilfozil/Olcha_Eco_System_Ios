import UIKit
import OlchaUI
import OlchaAuth
import OlchaPincode
import OlchaUtils
import OlchaCommon
import OlchaMarketModule
import OlchaVerification
import Combine
import OlchaCore

public protocol EcoAppCoordinatorProtocol: AppCoordinatorProtocol {
    var tabController: EcoMainTabBarController? { get }
    func notificationRouter(action: ClickActionModel)
}

public class EcoAppCoordinator {
    private var bag = Set<AnyCancellable>()
    public var authCoordinator: AuthCoordinatorProtocol
    public var pincodeCoordinator: PincodeCoordinatorProtocol
    public var tabController: EcoMainTabBarController?
    public var navigationController: UINavigationController
    public var commonCoordinator: CommonCoordinatorProtocol
    private let versionViewModel: VersionViewModel = CommonDIContainer.shared.resolve(argument: Organization.ecoSystem)
    
    public var isParent: Bool {
        ModuleGeneratorHelper.shared.parentModule == .ecosystem
    }
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        authCoordinator = AuthDIContainer.shared.resolve(argument: navigationController)
        pincodeCoordinator = PincodeCoordinator(navigationController: navigationController, state: .initial)
        commonCoordinator = CommonDIContainer.shared.resolve(argument: navigationController)
        EcoAppConfigurator.shared.appCoordinator = self
        versionViewModel.checkAppVersion(
            isModule: !isParent,
            version: Bundle.main.appVersionLong,
            url: Texts.appUrl.ecoSystemUrl
        )
        refreshAuthObserver()
    }
    
    
    private func refreshAuthObserver() {
        RefreshAuthObserver.shared.refreshExpireObserver.sink { [weak self] completion in
            guard let self else { return }
            navigationController.refreshAuthAlert {
                self.authCoordinator.pushAuth(isSet: false, canDismiss: false, completion: completion)
            }
        }.store(in: &bag)
    }
}

extension EcoAppCoordinator: EcoAppCoordinatorProtocol {
    
    public func presentPincode(completion: (() -> Void)?, logout: (() -> Void)?) {
        completion?()
    }
    
    public func presentInitialPincode(completion: (() -> Void)?) {
        completion?()
    }
    
    public func logout() {
        AuthNotificationManager.shared.postNotification()
        OlchaGlobalDefaults.logout()
        AuthGlobalDefaults.logout()
        PincodeGlobalDefaults.session.logout()
        VerificationGlobalDefaults.settings.logout()
        EcoAppConfigurator.shared.baseConfigure()
        loadCart()
        presentTabController(completion: nil)
    }
    
    public func presentTabController(completion: (() -> Void)?) {
        tabController = EcoMainTabBarController()
        tabController?.appCoordinator = self
        guard let tabController = tabController else {
            fatalError("\(#function) tabController")
        }
        navigationController.set([tabController], animated: false)
    }
    
    public func presentAuth(completion: (() -> Void)?) {
        completion?()
    }
    
    public func startSplash(completion: (() -> Void)?) {
        let vc: SplashScreenViewController = CommonDIContainer.shared.resolve()
        vc.setSplashImage(.olcha_eco)
        vc.splashCompletion = completion
        navigationController.set([vc])
    }
    
    public func start(appStarted: (() -> Void)?) {
        EcoAppConfigurator.shared.baseConfigure()
        loadCart()
        startApp(appStarted: appStarted)
    }
    
    public func startApp(appStarted: (() -> Void)?) {
        appFlow(state: .onboarding, appStarted: appStarted, isParent: false)
    }
    
    public func getPincodeState() -> AppStateFlow {
        return .pincode
    }
    
    public func presentOnboarding(completion: (() -> Void)?) {
        guard (CommonGlobalDefaults.session.isEntered ?? false) == false else { completion?(); return }
        commonCoordinator.pushOnboarding(completion: completion)
    }
    
}

public extension EcoAppCoordinator {
    func notificationRouter(action: ClickActionModel) {
        guard let action = action.getAction() else { return }
        let homeCoordinatlor = tabController?.homeCoordinator?.homeCoordinator
        homeCoordinatlor?.clickActionRouter(action: action)
    }
    
    func loadCart() {
        CartViewModel.shared.loadCart()
    }
}
