//
//  AppCoordinator.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 26/01/23.
//

import OlchaUI
import UIKit
import IQKeyboardManagerSwift
import OlchaAuth
import OlchaPincode
import OlchaUtils
import OlchaCommon
import OlchaVerification

public protocol PayAppCoordinatorProtocol: AppCoordinatorProtocol {

    var pincodeCoordinator: PincodeCoordinatorProtocol { get }
    
    var tabcontroller: PayMainTabbarController? { get }
    func deeplinkRouter(url: String)
    func notificationRouter(json: [AnyHashable: Any]?)
}

public class PayAppCoordinator: PayAppCoordinatorProtocol {
    
    
    public var navigationController: UINavigationController
    public var pincodeCoordinator: PincodeCoordinatorProtocol
    public var addCardCoordinator: AddCardCoordinatorProtocol
    public var authCoordinator: AuthCoordinatorProtocol
    private var commonCoordinator: CommonCoordinatorProtocol
    public var tabcontroller: PayMainTabbarController?
    private let versionViewModel: VersionViewModel = CommonDIContainer.shared.resolve(argument: Organization.pay)
    
    public var isParent: Bool {
        ModuleGeneratorHelper.shared.parentModule == .pay
    }
    
    public init(navigationController: BaseNavigation) {
        IQKeyboardManager.shared.enable = true
        self.navigationController = navigationController
        self.pincodeCoordinator = PincodeCoordinator(navigationController: navigationController, state: .initial)
        self.addCardCoordinator = AddCardCoordinator(navigationController: navigationController)
        versionViewModel.checkAppVersion(
            isModule: ModuleGeneratorHelper.shared.parentModule != .pay,
            version: Bundle.main.appVersionLong,
            url: Texts.appUrl.olchaInvestUrl
        )
        self.authCoordinator = AuthDIContainer.shared.resolve(argument: (navigationController as UINavigationController))
        self.commonCoordinator = CommonDIContainer.shared.resolve(argument: (navigationController as UINavigationController))
    }
    
    public func start(appStarted: (() -> Void)?) {
        startApp(appStarted: appStarted)
    }
    
    public func startSplash(completion: (() -> Void)?) {
        let vc: SplashScreenViewController = CommonDIContainer.shared.resolve()
        vc.setSplashImage(.olcha_pay)
        vc.splashCompletion = completion
        navigationController.set([vc])
    }
    
    public func startApp(appStarted: (() -> Void)?) {
        PayAppConfigurator.shared.baseConfiguration()
        appFlow(state: .onboarding, appStarted: appStarted, isParent: isParent)
    }
    
    public func logout() {
        
        AuthGlobalDefaults.logout()
        PincodeGlobalDefaults.session.logout()
        VerificationGlobalDefaults.settings.logout()
        if PayAppConfigurator.shared.isModule {
            ModuleGeneratorHelper.shared.generateParent()
        } else {
            PayAppConfigurator.shared.baseConfiguration()
            navigationController.popToRootViewController(animated: false)
            appFlow(state: .auth, appStarted: nil, isParent: isParent)
        }
    }
    
    public func presentInitialPincode(completion: (() -> Void)?) {
        pincodeCoordinator.startAddPincodeFlow()
        pincodeCoordinator.completion = completion
    }
    
    public func presentPincode(completion: (() -> Void)?, logout: (() -> Void)?) {
        pincodeCoordinator.startPincodeFlow()
        pincodeCoordinator.completion = completion
        pincodeCoordinator.logout = logout
    }
    
    public func presentAddCard(completion: (() -> Void)?) {
        addCardCoordinator.pushOnboardingAddCard(isSet: false)
        addCardCoordinator.completed = completion
    }
    
    public func presentOnboarding(completion: (() -> Void)?) {
        if PayAppConfigurator.shared.isModule {
             completion?()
        } else {
            guard (CommonGlobalDefaults.session.isEntered ?? false) == false else { completion?(); return }
            commonCoordinator.pushOnboarding(completion: completion)
        }
    }
    
    public func presentTabController(completion: (() -> Void)?) {
        PayAppConfigurator.shared.tabConfigurations()
        PayGlobalDefaults.session.isEntered = true
        self.tabcontroller = PayMainTabbarController()
        tabcontroller?.appCoordinator = self
        tabcontroller?.configureTabbars()
        guard let tabcontroller = tabcontroller else { return }
        let shouldAnimateTab = ModuleGeneratorHelper.shared.parentModule == .pay
        navigationController.set([tabcontroller], animated: shouldAnimateTab)
        completion?()
    }
    
    public func presentAuth(completion: (() -> Void)?) {
        guard !AuthGlobalDefaults.isUser() else { completion?(); return }
        authCoordinator.pushAuth(isSet: !PayAppConfigurator.shared.isModule,
                                 completion: completion)
        
    }
    
    public func getPincodeState() -> AppStateFlow {
        PincodeGlobalDefaults.session.isInitialPincode() ? .initialPincode : .pincode
    }
}

//MARK: - Deeplinks
extension PayAppCoordinator {
    
    public func clickActionRouter(action: ClickAction) {
        guard let action = action as? PayClickAction else { return }
        switch action {
        case .category(let categoryId):
//            Funcs.changeTab(PayTab.categories)
            let category = CategoryModel()
            category.id = categoryId
            tabcontroller?.payHomeCoordinator?.paymentsCoordinator.pushProvidersList(category: category)
        case .provider(let providerId):
//            Funcs.changeTab(PayTab.categories)
            guard let providerId else { return }
            tabcontroller?.payHomeCoordinator?.paymentsCoordinator.pushProvider(providerId: providerId)
        case .cards:
            Funcs.changeTab(PayTab.cards)
        case .pay:
            Funcs.changeTab(PayTab.home)
        case .categories:
            Funcs.changeTab(PayTab.categories)
        }
    }
    
    public func deeplinkRouter(url: String) {
        appFlow(state: .auth, appStarted: { [weak self] in
            guard let self = self else { return }
            let type = DeeplinkRouter.checkDeeplinkType(urlString: url)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                switch type {
                case .payment(let helper):
                    Funcs.changeTab(PayTab.home)
                    self.tabcontroller?.pushMakeTransaction(makePaymentHelper: helper)
                    break
                case .news(_):
                    break
                case .notification(_):
                    break
                case .none:
                    break
                }
            }
        }, isParent: isParent)
        
    }
    
    public func notificationRouter(json: [AnyHashable: Any]?) {
        guard let json = json else { return }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            let data: PushNotificationData? = try JSONDecoder().decode(
                PushNotificationData?.self,
                from: jsonData
            )
            notificationRouterPush(data: data)
            
        } catch {}
    }
    
    public func notificationRouterPush(data: PushNotificationData?) {
        guard let data = data else { return }
        appFlow(state: .auth, appStarted: { [weak self] in
            guard let self = self else { return }
            let type = NotificationRouter.checkNotificationType(data: data)
            switch type {
            case .payment(let helper):
                Funcs.changeTab(PayTab.home)
                self.tabcontroller?.pushMakeTransaction(makePaymentHelper: helper)
                break
            case .none:
                break
            }
        }, isParent: isParent)
    }
    
}
