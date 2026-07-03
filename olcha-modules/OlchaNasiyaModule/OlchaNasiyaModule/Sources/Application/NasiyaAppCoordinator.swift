//
//  NasiyaAppCoordinator.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import Combine
import OlchaUI
import OlchaAuth
import OlchaPincode
import OlchaUtils
import OlchaCommon
import OlchaVerification

public protocol NasiyaAppCoordinatorProtocol: AppCoordinatorProtocol {
    var tabcontroller: NasiyaMainTabbarController? { get }
    func notificationRouter(with notification: CloudNotification)
    func deeplinkRouter(url: String)
}

public class NasiyaAppCoordinator: NasiyaAppCoordinatorProtocol {
    
    private let viewModel: VersionViewModel = CommonDIContainer.shared.resolve(argument: Organization.nasiya)
    private let verificationViewModel: VerificationViewModel = OlchaVerificationDIContainer.shared.resolve()
    private var bag = Set<AnyCancellable>()
    private var shouldOpenProfileAfterStepLoad = false
    
    public var pincodeCoordinator: PincodeCoordinatorProtocol
    
    public var commonCoordinator: CommonCoordinatorProtocol
    
    public var authCoordinator: AuthCoordinatorProtocol
    
    public var tabcontroller: NasiyaMainTabbarController?
    
    public var navigationController: UINavigationController
    
    public lazy var deeplinkCoordinator: DeeplinkCoordinatorProtocol = {
        return DeeplinkCoordinator(handlers: [
            InstallmentDeeplinkHandler(tabbarController: tabcontroller),
            PayInstallmentDeeplinkHandler(tabbarController: tabcontroller),
            PartnerDeeplinkHandler(tabbarController: tabcontroller),
            LimitRequestDeeplinkHandler(tabbarController: tabcontroller),
        ])
    }()
    
    public var isParent: Bool {
        ModuleGeneratorHelper.shared.parentModule == .nasiya
    }
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        pincodeCoordinator = PincodeCoordinator(navigationController: navigationController, state: .initial)
        authCoordinator = AuthDIContainer.shared.resolve(argument: navigationController)
        commonCoordinator = CommonDIContainer.shared.resolve(argument: navigationController)
        viewModel.checkAppVersion(
            isModule: ModuleGeneratorHelper.shared.parentModule != .nasiya,
            version: Bundle.main.appVersionLong,
            url: Texts.appUrl.nasiyaUrl
        )
        setupVerificationStepObserver()
    }
    
    public func start(appStarted: (() -> Void)?) {
        startApp(appStarted: appStarted)
    }
    
    public func presentInitialPincode(completion: (() -> Void)?) {
        if NasiyaAppConfigurator.shared.isModule {
            completion?()
        } else {
            pincodeCoordinator.startAddPincodeFlow()
            pincodeCoordinator.completion = completion
        }
    }
    
    public func presentPincode(completion: (() -> Void)?, logout: (() -> Void)?) {
        if NasiyaAppConfigurator.shared.isModule {
            completion?()
        } else {
            pincodeCoordinator.startPincodeFlow()
            pincodeCoordinator.completion = completion
            pincodeCoordinator.logout = logout
        }
    }
    
    public func presentOnboarding(completion: (() -> Void)?) {
        if NasiyaAppConfigurator.shared.isModule {
            completion?()
        } else {
            guard (CommonGlobalDefaults.session.isEntered ?? false) == false else { completion?(); return }
            commonCoordinator.pushOnboarding(completion: completion)
        }
    }
    public func presentTabController(completion: (() -> Void)?) {
        tabcontroller = NasiyaMainTabbarController()
        tabcontroller?.appCoordinator = self
        guard let tabcontroller = tabcontroller else { return }
        let shouldAnimateTab = ModuleGeneratorHelper.shared.parentModule == .nasiya
        navigationController.set([tabcontroller], animated: shouldAnimateTab)
        completion?()
    }
    
    public func presentAuth(completion: (() -> Void)?) {
        guard !AuthGlobalDefaults.isUser() else { completion?(); return }
        authCoordinator.pushAuth(isSet: !NasiyaAppConfigurator.shared.isModule,
                                 completion: completion)
    }
    
    public func startSplash(completion: (() -> Void)?) {
        let vc: SplashScreenViewController = CommonDIContainer.shared.resolve()
        vc.setSplashImage(.olcha_nasiya)
        vc.splashCompletion = completion
        navigationController.set([vc])
    }
    
    public func startApp(appStarted: (() -> Void)?) {
        NasiyaAppConfigurator.shared.baseConfiguration()
        NasiyaAppConfigurator.shared.appCoordinator = self

        appFlow(
            state: .onboarding,
            appStarted: appStarted,
            isParent: isParent
        )
    }
    
    public func logout() {
        AuthGlobalDefaults.logout()
        PincodeGlobalDefaults.session.logout()
        VerificationGlobalDefaults.settings.logout()
        if NasiyaAppConfigurator.shared.isModule {
            ModuleGeneratorHelper.shared.generateParent()
        } else {
            NasiyaAppConfigurator.shared.baseConfiguration()
            navigationController.popToRootViewController(animated: false)
            appFlow(state: .auth, appStarted: nil, isParent: isParent)
        }
    }
    
    public func getPincodeState() -> AppStateFlow {
        PincodeGlobalDefaults.session.isInitialPincode() ? .initialPincode : .pincode
    }
}

public extension NasiyaAppCoordinator {
    

    func clickActionRouter(action: ClickAction) {
        guard let action = action as? NasiyaClickAction else { return }
        
        let homeCoordinator = tabcontroller?.nasiyaHomeCoordinator?.nasiyaHomeCoordinator
        let installmentsCoordinator = tabcontroller?.nasiyaHomeCoordinator?.installmentsCoordinator
        let partnerCoordinator = tabcontroller?.nasiyaHomeCoordinator?.partnerCoordinator
        let profileCoordinator = tabcontroller?.nasiyaHomeCoordinator?.profileCoordinator

        switch action {
        case .nasiya:
            selectTab(for: NasiyaTab.home)
        case .installment(let installmentId):
            installmentsCoordinator?.pushInstallment(
                installment: InstallmentModel(id: installmentId),
                shouldPay: false
            )
        case .limitCard:
            selectTab(for: NasiyaTab.home)
            homeCoordinator?.selectLimitCard()
        case .payInstallment(let installmentId):
            installmentsCoordinator?.pushInstallment(
                installment: InstallmentModel(id: installmentId),
                shouldPay: true
            )
        case .verification:
            profileCoordinator?.pushVerificationFlow()
        case .cards:
            profileCoordinator?.pushBankCards()
        case .stores:
            selectTab(for: NasiyaTab.partners)
        case .store(let storeId):
            partnerCoordinator?.pushPartnerInfo(partner: PartnerModel(slug: storeId?.description))
        case .profile:
            openProfileAfterStepCheck()
        }
    }
    
    func notificationRouter(with notification: CloudNotification) {
        let homeCoordinator = tabcontroller?.nasiyaHomeCoordinator?.nasiyaHomeCoordinator
        let installmentsCoordinator = tabcontroller?.installmentsCoordinator?.installmentsCoordinator
        let partnerCoordinator = tabcontroller?.partnerCoordinator?.partnerCoordinator
        let profileCoordinator = tabcontroller?.profileCoordinator?.profileCoordinator
        
        let route = NotificationRouteManager.route(from: notification)
        
        switch route {
        case .installment(let id):
            selectTab(for: NasiyaTab.installments)
            installmentsCoordinator?.pushInstallment(installment: InstallmentModel(id: id), shouldPay: false)
        case .limitCard:
            selectTab(for: NasiyaTab.home)
            homeCoordinator?.selectLimitCard()
        case .payInstallment(let id):
            selectTab(for: NasiyaTab.installments)
            installmentsCoordinator?.pushInstallment(installment: InstallmentModel(id: id), shouldPay: true)
        case .verification:
            selectTab(for: NasiyaTab.profile)
            profileCoordinator?.pushVerificationFlow()
        case .none: break
        }
    }
    
    func deeplinkRouter(url: String) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.deeplinkCoordinator.handleURL(url)            
        }
    }
    
    func selectTab(for index: Int) {
        tabcontroller?.selectedIndex = index
    }
    
}

private extension NasiyaAppCoordinator {

    func setupVerificationStepObserver() {
        verificationViewModel.$step
            .sink { [weak self] step in
                guard let self else { return }
                guard shouldOpenProfileAfterStepLoad else { return }
                switch step {
                case .success(let verificationData):
                    shouldOpenProfileAfterStepLoad = false
                    openProfile(with: verificationData)
                case .failure(let error):
                    shouldOpenProfileAfterStepLoad = false
                    navigationController.topViewController?.showError(text: error?.message)
                default:
                    break
                }
            }
            .store(in: &bag)
    }

    func openProfileAfterStepCheck() {
        guard !shouldOpenProfileAfterStepLoad else { return }
        shouldOpenProfileAfterStepLoad = true
        verificationViewModel.loadStep()
    }

    func openProfile(with verificationData: VerificationData?) {
        guard let verificationData else {
            selectTab(for: NasiyaTab.profile)
            tabcontroller?.profileCoordinator?.profileCoordinator.pushVerificationFlow()
            return
        }

        if verificationData.is_verified == true {
            navigationController.topViewController?.showSuccess(text: "verification_finish".localized())
            return
        }

        selectTab(for: NasiyaTab.profile)
        switch verificationData.step {
        case 0, 1:
            tabcontroller?.profileCoordinator?.profileCoordinator.pushPassportData()
        case 2:
            tabcontroller?.profileCoordinator?.profileCoordinator.pushPhones()
        case 3:
            tabcontroller?.profileCoordinator?.profileCoordinator.pushBankCards()
        default:
            tabcontroller?.profileCoordinator?.profileCoordinator.pushVerificationFlow()
        }
    }
}
