import UIKit
import Combine
import OlchaUI
import OlchaAuth
import OlchaUtils
import OlchaMarketModule

public class EcoMainTabBarController: UITabBarController {

    private var bag = Set<AnyCancellable>()
    public var authCoordinator: OlchaAuthCoordinatorProtocol?
    public var homeCoordinator: EcoMainCoordinatorProtocol?
    public var profileCoordinator: EcoMainCoordinatorProtocol?
    public var searchCoordinator: EcoMainCoordinatorProtocol?
    public weak var appCoordinator: EcoAppCoordinatorProtocol?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        configureTabbars()
        setCartCountObserver()
    }
    
    deinit {
        bag.forEach({ $0.cancel() })
    }

    public func configureTabbars() {
        tabBar.backgroundColor = .olchaWhite
        tabBar.tintColor = .olchaAccentColor
        
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.olchaLightTextColornnnnnn], for: .normal
        )
            
        UITabBarItem.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.white], for: .selected
        )
        
        let homeNavigationController = getNavigationController(title: EcoSystemTexts.tabNames[0].localized(.olchaEcoSystemCore),
                                                               image: .eco_olcha)
        homeCoordinator = EcoMainCoordinator(navigationController: homeNavigationController)
        homeCoordinator?.homeCoordinator.start()
        
        let marketNavigationController = getNavigationController(title: EcoSystemTexts.tabNames[1].localized(.olchaEcoSystemCore),
                                                                 image: .homeTabItem)
        
        let cartNavigationController = getNavigationController(title: EcoSystemTexts.tabNames[2].localized(.olchaEcoSystemCore),
                                                               image: .tab_cart)
        
        let searchNavigationController = getNavigationController(title: EcoSystemTexts.tabNames[3].localized(.olchaEcoSystemCore),
                                                                 image: .searchTabItem)
        searchCoordinator = EcoMainCoordinator(navigationController: searchNavigationController)
        searchCoordinator?.searchCoordinator.start()
        
        let profileNavigationController = getNavigationController(title: EcoSystemTexts.tabNames[4].localized(.olchaEcoSystemCore),
                                                                  image: .profileTabItem)
        profileCoordinator = EcoMainCoordinator(navigationController: profileNavigationController)
        profileCoordinator?.profileCoordinator.start()
        

        self.viewControllers = [
            homeNavigationController,
            marketNavigationController,
            cartNavigationController,
            searchNavigationController,
            profileNavigationController
        ]
    }
    
    
    private func getNavigationController(title: String, image: UIImage?, tag: Int = 0) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        let tabItem = UITabBarItem(
            title: title,
            image: image?.resizedImage(24),
            selectedImage: image?.resizedImage(24)?.withTintColor(.olchaAccentColor , renderingMode: .alwaysOriginal))
        tabItem.setTitleTextAttributes([
            .font: UIFont.style(.medium, 11),
            .foregroundColor: UIColor.olchaAccentColor
        ], for: .selected)
        
        tabItem.setTitleTextAttributes([
            .font: UIFont.style(.medium, 11),
            .foregroundColor: UIColor.olchaLightTextColornnnnnn
        ], for: .normal)
        navigationController.tabBarItem = tabItem
        return navigationController
    }
    
}

private extension EcoMainTabBarController {
    func setCartCountObserver() {
        CartViewModel.shared.$cartCount
            .sink { [weak self] count in
                guard let self, let items = tabBar.items else { return }
                let tabItem = items[EcoTab.cart]
                tabItem.badgeValue = max(0, count).string
            }.store(in: &bag)
    }
}

extension EcoMainTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let navigationController else { return false }
        let index = tabBarController.viewControllers?.firstIndex(where: { $0 == viewController })
        
        if EcoSystemTexts.market(index) {
            ModuleGeneratorHelper.shared.generate(module: .olcha, appStarted: nil)
            return false
        }
        
        if EcoSystemTexts.cart(index) {
            //            if AuthGlobalDefaults.isUser() {
            homeCoordinator?.pushMarketAction()
            return false
        }
        //                authCoordinator = nil
        //                authCoordinator = OlchaAuthCoordinator(navigationController: navigationController)
        //                authCoordinator?.pushAuth(isSet: false) { [weak self] in
        //                    guard let self, let index else { return }
        //                    selectedIndex = index
        //                    homeCoordinator?.pushMarketAction()
//                }
//            }
//        }
        
        return true
    }
}
