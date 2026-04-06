//
//  MainTabbarController.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/11/22.
//

import UIKit
import OlchaAuth
import OlchaUtils
public class OlchaMainTabbarController: UITabBarController, UITabBarControllerDelegate {
    
    public var authCoordinator: OlchaAuthCoordinatorProtocol?
    
    public var homeCoordinator: OlchaMainCoordinator?
    public var catalogCoordinator: OlchaMainCoordinator?
    public var profileCoordinator: OlchaMainCoordinator?
    public var cartCoordinator: OlchaMainCoordinator?
    public var favouriteCoordinator: OlchaMainCoordinator?
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = (self as? UITabBarControllerDelegate)
        
        tabBar.tintColor = .olchaAccentColor
        tabBar.unselectedItemTintColor = .olchaLightTextColornnnnnn
        configureTabbars()
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        defer {
            tabBarController.tabBar.isHidden = false
        }
        let index = tabBarController.viewControllers?.firstIndex(where: { $0 == viewController })
        var navigationController: UINavigationController?
        
        if tabBarController.selectedIndex < (tabBarController.viewControllers?.count ?? 0) {
            navigationController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? UINavigationController
        }
        
//        if (index == OlchaTab.cart) && !AuthGlobalDefaults.isUser() {
//            if let navigationController = navigationController {
//                authCoordinator = nil
//                authCoordinator = OlchaAuthCoordinator(navigationController: navigationController)
//                
//                authCoordinator?.pushAuth(isSet: false) { [weak self] in
//                    guard let self = self,
//                          let index = index else { return }
//                    
//                    selectedIndex = index
//                }
//                return false
//            }
//        }
        
        if OlchaTab.back(index) {
            ModuleGeneratorHelper.shared.generateParent()
            return false
        }
        return true
    }
    
    private func configureTabbars() {
        let backNavigationController = getNavigationController(tab: .back)
        let homeNavigationController = getNavigationController(tab: .mainTab)
        let catalogNavigationController = getNavigationController(tab: .catalog)
        let profileNavigationController = getNavigationController(tab: .profile)
        let cartNavigationController = getNavigationController(tab: .cart)
        let favouriteNavigationController = getNavigationController(tab: .favourite)
        
        homeCoordinator = OlchaMainCoordinator(navigationController: homeNavigationController)
        homeCoordinator?.homeCoordinator.start()
        
        catalogCoordinator = OlchaMainCoordinator(navigationController: catalogNavigationController)
        catalogCoordinator?.catalogCoordinator.start()
        
        profileCoordinator = OlchaMainCoordinator(navigationController: profileNavigationController)
        profileCoordinator?.profileCoordinator.start()
        
        cartCoordinator = OlchaMainCoordinator(navigationController: cartNavigationController)
        cartCoordinator?.cartCoordinator.start()
        
        favouriteCoordinator = OlchaMainCoordinator(navigationController: favouriteNavigationController)
        favouriteCoordinator?.profileCoordinator.setFavourites()
        
        self.viewControllers = [
            OlchaApplicationConfigurator.shared.isModule ? backNavigationController : nil,
            homeNavigationController,
            catalogNavigationController,
            cartNavigationController,
            OlchaApplicationConfigurator.shared.isModule ? nil : favouriteNavigationController,
            profileNavigationController
        ].compactMap { $0 }
        
        initShadow()
        enableShadow()
        
        selectedIndex = OlchaTab.home
    }
    
    private func getNavigationController(tab: Tab, tag: Int = 0) -> UINavigationController {
        let navigationController = UINavigationController()
        
        let tabItem = UITabBarItem(
            title: tab.title,
            image: tab.image?.resizedImage(24),
            selectedImage: tab.image?.resizedImage(24)?.withTintColor(.olchaAccentColor , renderingMode: .alwaysOriginal))
        tabItem.setTitleTextAttributes([
            .font: UIFont.style(.medium, 11),
            .foregroundColor: UIColor.olchaAccentColor],
                                       for: .selected)
        
        tabItem.setTitleTextAttributes([
            .font: UIFont.style(.medium, 11),
            .foregroundColor: UIColor.olchaLightTextColornnnnnn],
                                       for: .normal)
        
        navigationController.tabBarItem = tabItem
        
        return navigationController
    }
}
