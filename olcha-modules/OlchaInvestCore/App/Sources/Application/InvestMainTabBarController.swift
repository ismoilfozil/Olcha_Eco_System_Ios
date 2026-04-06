//
//  InvestMainTabBarController.swift
//  OlchaInvestModule
//
//  Created by Akhrorkhuja on 15/05/23.
//

import UIKit
import OlchaUtils

public class InvestMainTabBarController: UITabBarController {

    var mainCoordinator: InvestMainCoordinatorProtocol?
    var investmentsCoordinator: PackagesCoordinatorProtocol?
    var profileCoordinator: ProfileCoordinatorProtocol?
    weak var appCoordinator: InvestAppCoordinatorProtocol?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        configureTabbars()
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
        
        InvestAppConfigurator.shared.isModule ? configureModuleTabBar() : configureAppTabBar()
        
        selectedIndex = InvestTab.home
    }
    
    private func configureModuleTabBar() {
        let mainNavigationController = getNavigationController(title: InvestTexts.tabNames[0].localized(.olchaInvestCore), image: .eco_olcha)
        
        let homeNavigationController = getNavigationController(title: InvestTexts.tabNames[1].localized(.olchaInvestCore), image: .investHomeTabItem)
        mainCoordinator = InvestMainCoordinator(navigationController: homeNavigationController)
        mainCoordinator?.investHomeCoordinator.start()
        
        let rateNavigationController = getNavigationController(title: InvestTexts.tabNames[2].localized(.olchaInvestCore), image: .investRateTabItem)
        investmentsCoordinator = PackagesCoordinator(navigationController: rateNavigationController)
        investmentsCoordinator?.start()
        
        let profileNavigationController = getNavigationController(title: InvestTexts.tabNames[3].localized(.olchaInvestCore), image: .investProfileTabItem)
        profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        profileCoordinator?.start()
        
        self.viewControllers = [
            mainNavigationController,
            homeNavigationController,
            rateNavigationController,
            profileNavigationController
        ].compactMap { $0 }
    }
    
    private func configureAppTabBar() {
        
        let homeNavigationController = getNavigationController(title: InvestTexts.tabNames[0].localized(.olchaInvestCore), image: .investHomeTabItem)
        mainCoordinator = InvestMainCoordinator(navigationController: homeNavigationController)
        mainCoordinator?.investHomeCoordinator.start()
        
        let rateNavigationController = getNavigationController(title: InvestTexts.tabNames[1].localized(.olchaInvestCore), image: .investRateTabItem)
        investmentsCoordinator = PackagesCoordinator(navigationController: rateNavigationController)
        investmentsCoordinator?.start()
        
        let profileNavigationController = getNavigationController(title: InvestTexts.tabNames[2].localized(.olchaInvestCore), image: .investProfileTabItem)
        profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        profileCoordinator?.start()
        
        self.viewControllers = [
            homeNavigationController,
            rateNavigationController,
            profileNavigationController
        ].compactMap { $0 }
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

extension InvestMainTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = tabBarController.viewControllers?.firstIndex(where: { $0 == viewController })
        
        if InvestTab.back(index) {
            ModuleGeneratorHelper.shared.generateParent()
            return false
        }
        return true
    }
}
