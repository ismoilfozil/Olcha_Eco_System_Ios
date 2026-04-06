//
//  MainTabbarController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 01/02/23.
//

import UIKit
import OlchaUI
import OlchaUtils

public class PayMainTabbarController: UITabBarController, UITabBarControllerDelegate, UIGestureRecognizerDelegate {
    
    var payHomeCoordinator: PayMainCoordinator?
    var mainCardsCoordinator: PayMainCoordinator?
    var paymentsCoordinator: PayMainCoordinator?
    var profileCoordinator: PayMainCoordinator?
    var monitoringCoordinator: PayMainCoordinator?
    
    weak var appCoordinator: PayAppCoordinatorProtocol?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = (self as? UITabBarControllerDelegate)
        configureTabbars()
    }
    
    func pushMakeTransaction(makePaymentHelper: MakePaymentHelper) {
        payHomeCoordinator?.payHomeCoordinator.pushMakeTransaction(makePaymentHelper: makePaymentHelper)
    }
    
}

extension PayMainTabbarController {
    func getNavigationController(title: String, image: UIImage?, tag: Int = 0) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        let tabItem = UITabBarItem(
            title: title,
            image: image?.resizedImage(24),
            selectedImage: image?.resizedImage(24)?.withTintColor(.olchaAccentColor , renderingMode: .alwaysOriginal))
        tabItem.setTitleTextAttributes([
            .font: UIFont.style(.medium, 11),
            .foregroundColor: UIColor.olchaAccentColor
        ],
                                       
                                       for: .selected)
        
        tabItem.setTitleTextAttributes([
            .font: UIFont.style(.medium, 11),
            .foregroundColor: UIColor.olchaLightTextColornnnnnn],
                                       
                                       for: .normal)
        navigationController.tabBarItem = tabItem
        return navigationController
    }
}

extension PayMainTabbarController {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = tabBarController.viewControllers?.firstIndex(where: { $0 == viewController })
        
        if PayTab.back(index) {
            ModuleGeneratorHelper.shared.generateParent()
            return false
        }
        return true
    }
    
    func configureTabbars() {
        tabBar.backgroundColor = .olchaWhite
        tabBar.tintColor = .olchaAccentColor
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.olchaLightTextColornnnnnn], for: .normal)
            
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.olchaAccentColor], for: .selected)
        
//
//        tabcontroller.initShadow()
//        tabcontroller.enableShadow()
        
        PayAppConfigurator.shared.isModule ? configureModuleTabBar() : configureAppTabBar()
        
        self.selectedIndex = PayTab.home
    }
    
    private func configureAppTabBar() {
        let homeNavigationController = getNavigationController(title: PayTexts.tabNames[0].localized(), image: .pay_main_tab)
        let mainCardsNavigationController = getNavigationController(title: PayTexts.tabNames[1].localized(), image: .pay_cards_tab)
        let paymentsNavigationController = getNavigationController(title: PayTexts.tabNames[2].localized(), image: .pay_payments_tab)
        let monitoringNavigationController = getNavigationController(title: PayTexts.tabNames[3].localized(), image: .monitoring)
        let profileNavigationController = getNavigationController(title: PayTexts.tabNames[4].localized(), image: .tab_profile)
        
        payHomeCoordinator = PayMainCoordinator(navigationController: homeNavigationController)
        payHomeCoordinator?.payHomeCoordinator.start()
        
        mainCardsCoordinator = PayMainCoordinator(navigationController: mainCardsNavigationController)
        mainCardsCoordinator?.mainCardsCoordinator.start()
        
        paymentsCoordinator = PayMainCoordinator(navigationController: paymentsNavigationController)
        paymentsCoordinator?.paymentsCoordinator.start()
        
        profileCoordinator = PayMainCoordinator(navigationController: profileNavigationController)
        profileCoordinator?.profileCoordinator.start()
        
        monitoringCoordinator = PayMainCoordinator(navigationController: monitoringNavigationController)
        monitoringCoordinator?.monitoringCoordinator.start()
        
        
        self.viewControllers = [
            homeNavigationController,
            mainCardsNavigationController,
            paymentsNavigationController,
            monitoringNavigationController,
            profileNavigationController
        ].compactMap { $0 }
    }
    
    private func configureModuleTabBar() {
        let mainNavigationController = getNavigationController(title: PayTexts.tabNames[0].localized(), image: .eco_olcha)
        let homeNavigationController = getNavigationController(title: PayTexts.tabNames[1].localized(), image: .pay_main_tab)
        let mainCardsNavigationController = getNavigationController(title: PayTexts.tabNames[2].localized(), image: .pay_cards_tab)
        let paymentsNavigationController = getNavigationController(title: PayTexts.tabNames[3].localized(), image: .pay_payments_tab)
        let monitoringNavigationController = getNavigationController(title: PayTexts.tabNames[4].localized(), image: .monitoring)
        
        payHomeCoordinator = PayMainCoordinator(navigationController: homeNavigationController)
        payHomeCoordinator?.payHomeCoordinator.start()
        
        mainCardsCoordinator = PayMainCoordinator(navigationController: mainCardsNavigationController)
        mainCardsCoordinator?.mainCardsCoordinator.start()
        
        paymentsCoordinator = PayMainCoordinator(navigationController: paymentsNavigationController)
        paymentsCoordinator?.paymentsCoordinator.start()
        
        monitoringCoordinator = PayMainCoordinator(navigationController: monitoringNavigationController)
        monitoringCoordinator?.monitoringCoordinator.start()
        
        
        self.viewControllers = [
            mainNavigationController,
            homeNavigationController,
            mainCardsNavigationController,
            paymentsNavigationController,
            monitoringNavigationController
        ].compactMap { $0 }
    }
}
