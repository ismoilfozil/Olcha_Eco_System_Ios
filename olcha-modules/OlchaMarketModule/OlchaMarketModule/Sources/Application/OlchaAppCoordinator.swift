//
//  AppCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/06/22.
//
import OlchaAuth
import UIKit
import OlchaUI
import OlchaVerification
import OlchaUtils
import OlchaCommon

public protocol OlchaAppCoordinatorProtocol: AppCoordinatorProtocol {
    
    var tabcontroller: OlchaMainTabbarController { get }
    func startSplash(appStarted: (() -> Void)?)
    func startTabbar(appStarted: (() -> Void)?)
    func start(appStarted: (() -> Void)?)
    func logout()
    
    func notificationRouter(notification: CloudMessagingData?)
    func deeplinkRouter(url: String)
}

public class OlchaAppCoordinator: OlchaAppCoordinatorProtocol {
    
    public var authCoordinator: AuthCoordinatorProtocol
    public var navigationController: UINavigationController
    
    public func presentTabController(completion: (() -> Void)?) {
        startTabbar(appStarted: completion)
    }
    
    public func presentAuth(completion: (() -> Void)?) {
        completion?()
    }

    public func presentPincode(completion: (() -> Void)?, logout: (() -> Void)?) {
        completion?()
    }
    
    public func startSplash(completion: (() -> Void)?) {
        startSplash(appStarted: completion)
    }
    
    public func getPincodeState() -> OlchaUI.AppStateFlow {
        return .home
    }
    
    public var tabcontroller: OlchaMainTabbarController
    private let versionViewModel: OlchaCommon.VersionViewModel = CommonDIContainer.shared.resolve(argument: Organization.market)
        
    public init(navigationController: BaseNavigation) {
        self.navigationController = navigationController
        self.tabcontroller = OlchaMainTabbarController()
        self.authCoordinator = AuthDIContainer.shared.resolve(argument: navigationController as UINavigationController)
        versionViewModel.checkAppVersion(
            isModule: ModuleGeneratorHelper.shared.parentModule != .olcha,
            version: Bundle.main.appVersionLong,
            url: Texts.appUrl.olchaUrl
        )
    }
    
    public func start(appStarted: (() -> Void)?) {
        OlchaApplicationConfigurator.shared.baseConfiguration()
        if ModuleGeneratorHelper.shared.parentModule == .olcha {
            startSplash(appStarted: appStarted)
        } else {
            startTabbar(appStarted: appStarted)
        }
        
//        AuthViewModel.shared.getToken()
        CartViewModel.shared.loadCart()
        CartViewModel.shared.loadFavourites(page: 1)
        OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
    }
    
    public func startSplash(appStarted: (() -> Void)?) {
        let vc: SplashScreenViewController = CommonDIContainer.shared.resolve()
        vc.setSplashImage(.olcha_market)
        vc.splashCompletion = { [weak self] in
            guard let self else { return }
            startTabbar(appStarted: appStarted)
        }
        navigationController.set([vc])
    }
    
    public func startTabbar(appStarted: (() -> Void)?) {
        let shouldAnimateTab = ModuleGeneratorHelper.shared.parentModule == .olcha
        navigationController.set([self.tabcontroller], animated: shouldAnimateTab)
        appStarted?()
        
        /// `Check loyalty`
        checkLoyalty()
    }
    
    public func logout() {
        OlchaGlobalDefaults.logout()
        VerificationGlobalDefaults.settings.logout()
        self.tabcontroller = OlchaMainTabbarController()
        navigationController.set([self.tabcontroller])
        
        CartViewModel.shared.loadCart()
        CartViewModel.shared.loadFavourites(page: 1)
    }
    
    public func notificationRouter(notification: CloudMessagingData?) {
        let route = NotificationRouterManager.shared.route(data: notification)
        tabcontroller.selectedIndex = OlchaTab.home
        switch route {
        case .product(let product):
            tabcontroller.homeCoordinator?.productCoordinator.pushProductPage(product: product, animated: false)
            break
        case .other:
            tabcontroller.homeCoordinator?.profileCoordinator.pushNotifications()
            break
        case .installmentPayment(let link):
            tabcontroller.homeCoordinator?.profileCoordinator.pushOrderPay(urlString: link)
            break
        case .orderStatus(let order):
            tabcontroller.homeCoordinator?.profileCoordinator.pushOrder(order: order)
            break
        case .link(let url):
            Funcs.openSafari(urlString: url ?? "")
            break
        case .catalog(let category):
            let filters = ProductListFilters()
            filters.category = category
            
            tabcontroller.homeCoordinator?.productCoordinator.pushProductsList(filters: filters, animated: false)
            break
        case .brand(let brand):
            if let brand = brand {
                tabcontroller.homeCoordinator?.brandsCoordinator.pushBrandProducts(filters: ProductListFilters().setStaticManufacturer(brand))
            }
            break
        case .ramadan:
            tabcontroller.homeCoordinator?.profileCoordinator.pushRamazanTaqvim()
            break
        case .productsList(let filters):
            tabcontroller.homeCoordinator?.homeCoordinator.pushProductsList(with: filters)
            break
        case .none:
            break
        }
    }
    
    public func deeplinkRouter(url: String) {
        let type = DeeplinkEditor.checkDeeplinkType(urlString: url)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.tabcontroller.selectedIndex = OlchaTab.home
            switch type {
            case .product(let model):
                tabcontroller.homeCoordinator?.productCoordinator.pushProductPage(product: model, animated: false)
                break
            case .category(let model):
                let filters = ProductListFilters()
                filters.category = model
                tabcontroller.homeCoordinator?.productCoordinator.pushProductsList(filters: filters, animated: false)
                break
            case .brand(let manufacturer, let category):
                let filters = ProductListFilters()
                filters.category = category
                filters.selectedManufacturer = manufacturer
                tabcontroller.homeCoordinator?.productCoordinator.pushProductsList(filters: filters, animated: false)
                break
            case .products(let filter):
                tabcontroller.homeCoordinator?.productCoordinator.pushProductsList(filters: filter)
            default: break
            }
        }
        
    }
    
    private func checkLoyalty() {
        LoyaltyManager.shared.showNextLevel {
            LoyaltyManager.shared.presentNextLevel()
        }
    }
}

extension OlchaAppCoordinator {
    public func clickActionRouter(action: ClickAction) {
        guard let action = action as? MarketClickAction else { return }
        switch action {
        case .category(let categoryId):
            guard let categoryId else { return }
            let filters = ProductListFilters()
            filters.category = CategoryModel(id: categoryId)
            tabcontroller.homeCoordinator?.productCoordinator.pushProductsList(filters: filters, animated: false)
        case .brand(let brandId):
            guard let brandId else { return }
            let filters = ProductListFilters()
            filters.selectedManufacturer = Manufacturer(id: brandId)
            tabcontroller.homeCoordinator?.productCoordinator.pushProductsList(filters: filters, animated: false)
        case .product(let productId):
            guard let productId else { return }
            let product = Funcs.getProductModel(id: productId)
            tabcontroller.homeCoordinator?.productCoordinator.pushProductPage(product: product, animated: false)
        case .orders:
            checkIsUser { [weak self] in
                guard let self else { return }
                tabcontroller.homeCoordinator?.profileCoordinator.pushMyOrdersPage(animated: false)
            }
        case .order(let orderId):
            checkIsUser { [weak self] in
                guard let self else { return }
                tabcontroller.homeCoordinator?.profileCoordinator.pushOrder(order: .init(id: orderId))
            }
        case .orderReturn:
            tabcontroller.homeCoordinator?.profileCoordinator.pushReturnOrder(animated: false)
        case .favorites:
            checkIsUser { [weak self] in
                guard let self else { return }
                tabcontroller.homeCoordinator?.profileCoordinator.pushFavourites(animated: false)                
            }
        case .comments:
            checkIsUser { [weak self] in
                guard let self else { return }
                tabcontroller.homeCoordinator?.profileCoordinator.pushMyReviews(type: .review, animated: false)
            }
        case .compare:
            tabcontroller.homeCoordinator?.profileCoordinator.pushCompare(product: nil, animated: false)
        case .questions:
            checkIsUser { [weak self] in
                guard let self else { return }
                tabcontroller.homeCoordinator?.profileCoordinator.pushMyReviews(type: .question, animated: false)
            }
        case .addresses:
            checkIsUser { [weak self] in
                guard let self else { return }
                tabcontroller.homeCoordinator?.profileCoordinator.pushLocationsList(animated: false)
            }
        case .personalData:
            checkIsUser { [weak self] in
                guard let self else { return }
                tabcontroller.homeCoordinator?.profileCoordinator.pushVerificationPage1()
            }
        case .profileBonus:
            checkIsUser { [weak self] in
                guard let self else { return }
                tabcontroller.selectedIndex = OlchaTab.profile
                tabcontroller.profileCoordinator?.profileCoordinator.selectBonus()
            }
        case .profileBalance:
            checkIsUser { [weak self] in
                guard let self else { return }
                tabcontroller.selectedIndex = OlchaTab.profile
                tabcontroller.profileCoordinator?.profileCoordinator.selectBalance()
            }
        case .cart:
            checkIsUser { [weak self] in
                guard let self else { return }
                tabcontroller.selectedIndex = OlchaTab.cart
            }
        case .catalog:
            tabcontroller.selectedIndex = OlchaTab.catalog
        case .market:
            tabcontroller.selectedIndex = OlchaTab.home
        case .seller(let sellerId):
            let filter = ProductListFilters()
            filter.stores = [Store(id: sellerId)]
            tabcontroller.homeCoordinator?.productCoordinator.pushProductsList(filters: filter, animated: false)
        case .order(orderId: let orderId):
            tabcontroller.homeCoordinator?.profileCoordinator.pushOrder(order: .init(id: orderId))
        }
    }
}

private extension OlchaAppCoordinator {
    func checkIsUser(completion: @escaping () -> Void) {
        if AuthGlobalDefaults.isUser() {
            completion()
        } else {
            authCoordinator.pushAuth(isSet: false, completion: completion)
        }
    }
}
