//
//  InvestAppCoordinator.swift
//  OlchaInvestModule
//
//  Created by Akhrorkhuja on 15/05/23.
//

import UIKit
import OlchaUI
import OlchaAuth
import OlchaPincode
import OlchaUtils
import OlchaCommon
import OlchaVerification

public protocol InvestAppCoordinatorProtocol: AppCoordinatorProtocol {
    var tabController: InvestMainTabBarController? { get }

    func notificationRouter(with notification: CloudNotification)
}

public class InvestAppCoordinator {
    
    public var authCoordinator: AuthCoordinatorProtocol
    public var pincodeCoordinator: PincodeCoordinatorProtocol
    public var commonCoordinator: CommonCoordinatorProtocol
    public var tabController: InvestMainTabBarController?
    public var navigationController: UINavigationController
    private let versionViewModel: VersionViewModel = CommonDIContainer.shared.resolve(argument: Organization.invest)
    
    public var isParent: Bool {
        ModuleGeneratorHelper.shared.parentModule == .invest
    }
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        authCoordinator = AuthDIContainer.shared.resolve(argument: navigationController)
        pincodeCoordinator = PincodeCoordinator(navigationController: navigationController, state: .initial)
        commonCoordinator = CommonDIContainer.shared.resolve(argument: navigationController)
        InvestAppConfigurator.shared.appCoordinator = self
        versionViewModel.checkAppVersion(
            isModule: !isParent,
            version: Bundle.main.appVersionLong,
            url: Texts.appUrl.olchaInvestUrl
        )
    }
    
}

extension InvestAppCoordinator: InvestAppCoordinatorProtocol {
    
    
    public func presentPincode(completion: (() -> Void)?, logout: (() -> Void)?) {
        if InvestAppConfigurator.shared.isModule {
            completion?()
        } else {
            pincodeCoordinator.startPincodeFlow()
            pincodeCoordinator.completion = completion
            pincodeCoordinator.logout = logout
        }
    }
    
    public func presentInitialPincode(completion: (() -> Void)?) {
        if InvestAppConfigurator.shared.isModule {
            completion?()
        } else {
            pincodeCoordinator.startAddPincodeFlow()
            pincodeCoordinator.completion = completion
        }
    }
    
    public func logout() {
        AuthGlobalDefaults.logout()
        PincodeGlobalDefaults.session.logout()
        VerificationGlobalDefaults.settings.logout()
        if InvestAppConfigurator.shared.isModule {
            ModuleGeneratorHelper.shared.generateParent()
        } else {
            InvestAppConfigurator.shared.baseConfigure()
            navigationController.popToRootViewController(animated: false)
            appFlow(state: .auth, appStarted: nil, isParent: isParent)
        }
    }
    
    public func presentTabController(completion: (() -> Void)?) {
        tabController = InvestMainTabBarController()
        tabController?.appCoordinator = self
        guard let tabController = tabController else {
            fatalError("\(#function) tabController")
        }
        navigationController.set([tabController], animated: isParent)
        completion?()
    }
    
    public func presentAuth(completion: (() -> Void)?) {
        guard !AuthGlobalDefaults.isUser() else {
            completion?()
            return
        }
        authCoordinator.pushAuth(isSet: !InvestAppConfigurator.shared.isModule, completion: completion)
    }
    
    public func startSplash(completion: (() -> Void)?) {
        let vc: SplashScreenViewController = CommonDIContainer.shared.resolve()
        vc.setSplashImage(.olcha_invest)
        vc.splashCompletion = completion
        navigationController.set([vc])
    }
    
    public func start(appStarted: (() -> Void)?) {
        InvestAppConfigurator.shared.baseConfigure()
        startApp(appStarted: appStarted)
    }
    

    public func startApp(appStarted: (() -> Void)?) {
        appFlow(
            state: .onboarding,
            appStarted: appStarted,
            isParent: isParent
        )
    }
    
    public func getPincodeState() -> AppStateFlow {
        PincodeGlobalDefaults.session.isInitialPincode() ? .initialPincode : .pincode
    }
    
    public func presentOnboarding(completion: (() -> Void)?) {
        if InvestAppConfigurator.shared.isModule {
            completion?()
        } else {
            guard (CommonGlobalDefaults.session.isEntered ?? false) == false else { completion?(); return }
            commonCoordinator.pushOnboarding(completion: completion)
        }
    }
    
}

public extension InvestAppCoordinator {
    
    public func clickActionRouter(action: ClickAction) {
        guard let action = action as? InvestClickAction else { return }

        let homeCoordinator = tabController?.mainCoordinator?.investHomeCoordinator
        let menuCoordinator = tabController?.mainCoordinator?.menuCoordinator
        let packageCoordinator = tabController?.investmentsCoordinator
        let profileCoordinator = tabController?.profileCoordinator
        
        switch action {
        case .invest:
            selectTab(for: .home)
        case .addInvest:
            selectTab(for: .home)
            homeCoordinator?.pushInvestViewController()
        case .news:
            selectTab(for: .home)
            menuCoordinator?.pushSuggestionsViewController()
        case .newsDetail(let postId):
            guard let postId else { return }
            selectTab(for: .home)
            menuCoordinator?.pushSuggestionsViewController()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                menuCoordinator?.pushSuggestionDetailViewController(id: postId)
            }
        case .packages:
            selectTab(for: .packages)
        case .packagesDetail(let packageId):
            guard let packageId else { return }
            selectTab(for: .packages)
            packageCoordinator?.pushPackagesDetailViewController(investmentId: packageId)
        case .profile:
            selectTab(for: .profile)
        case .balance(let balanceId):
            guard let balanceId else { return }
            selectTab(for: .profile)
            profileCoordinator?.selectBalance(balanceId: balanceId)
        }
    }
    
    func notificationRouter(with notification: CloudNotification) {
        let homeCoordinator = tabController?.mainCoordinator?.investHomeCoordinator
        let menuCoordinator = tabController?.mainCoordinator?.menuCoordinator
        let packageCoordinator = tabController?.investmentsCoordinator
        let profileCoordinator = tabController?.profileCoordinator
        
        let route = NotificationManager.default.route(from: notification)
        switch route {
        case .addInvest:
            selectTab(for: .home)
            homeCoordinator?.pushInvestViewController()
        case .contractDetail(let contractId):
            selectTab(for: .home)
            homeCoordinator?.pushContractViewController(contractId: contractId)
        case .news:
            selectTab(for: .home)
            menuCoordinator?.pushSuggestionsViewController()
        case .newsDetail(let postId):
            selectTab(for: .home)
            menuCoordinator?.pushSuggestionsViewController()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                menuCoordinator?.pushSuggestionDetailViewController(id: postId)
            }
        case .message(let title, let description):
            selectTab(for: .home)
            homeCoordinator?.showPopUpViewController(title: title, description: description)
        case .package(let packageId):
            selectTab(for: .packages)
            packageCoordinator?.pushPackagesDetailViewController(investmentId: packageId)
        case .withdraw(let contractId):
            selectTab(for: .home)
            homeCoordinator?.pushInvestProfitViewController(contractId: contractId)
        case .showProfile:
            selectTab(for: .profile)
        case .showBalance(let balanceId):
            selectTab(for: .profile)
            profileCoordinator?.selectBalance(balanceId: balanceId)
        case .none: break
        }
    }
    
    enum TabName {
        case home
        case packages
        case profile
    }
    
    func selectTab(for tab: TabName) {
        switch tab {
        case .home:
            tabController?.selectedIndex = InvestTab.home
        case .packages:
            tabController?.selectedIndex = InvestTab.packages
        case .profile:
            tabController?.selectedIndex = InvestTab.profile
        }
    }
    
}
