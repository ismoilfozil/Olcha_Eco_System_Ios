//
//  NasiyaMainTabbarController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import OlchaUI
import OlchaUtils
public class NasiyaMainTabbarController: UITabBarController, UITabBarControllerDelegate, UIGestureRecognizerDelegate {
    
    var nasiyaHomeCoordinator: NasiyaMainCoordinator?
    var installmentsCoordinator: NasiyaMainCoordinator?
    var partnerCoordinator: NasiyaMainCoordinator?
    var profileCoordinator: NasiyaMainCoordinator?
    
    weak var appCoordinator: NasiyaAppCoordinatorProtocol?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = (self as? UITabBarControllerDelegate)
        configureTabbars()
    }
    
    public func configureTabbars() {
        tabBar.backgroundColor = .olchaWhite
        tabBar.tintColor = .olchaAccentColor
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.olchaLightTextColornnnnnn], for: .normal)
            
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.olchaAccentColor], for: .selected)
        

        NasiyaAppConfigurator.shared.isModule ? configureModuleTabBar() : configureAppTabBar()
        
        self.selectedIndex = NasiyaTab.home
    }
    
    private func configureModuleTabBar() {
        let mainNavigationController = getNavigationController(title: NasiyaTexts.tabNames[0].localized(.olchaNasiyaModule), image: .eco_olcha)
        let homeNavigationController = getNavigationController(title: NasiyaTexts.tabNames[1].localized(.olchaNasiyaModule), image: .nasiya_home_tab)
        let installmentsNavigationController = getNavigationController(title: NasiyaTexts.tabNames[2].localized(.olchaNasiyaModule), image: .nasiya_applications_tab)
        let partnerNavigationController = getNavigationController(title: NasiyaTexts.tabNames[3].localized(.olchaNasiyaModule), image: .nasiya_partners_tab)
        let profileNavigationController = getNavigationController(title: NasiyaTexts.tabNames[4].localized(.olchaNasiyaModule), image: .nasiya_profile_tab)


        nasiyaHomeCoordinator = NasiyaMainCoordinator(navigationController: homeNavigationController)
        nasiyaHomeCoordinator?.nasiyaHomeCoordinator.start()
        
        installmentsCoordinator = NasiyaMainCoordinator(navigationController: installmentsNavigationController)
        installmentsCoordinator?.installmentsCoordinator.start()
        
        partnerCoordinator = NasiyaMainCoordinator(navigationController: partnerNavigationController)
        partnerCoordinator?.partnerCoordinator.start()
        
        profileCoordinator = NasiyaMainCoordinator(navigationController: profileNavigationController)
        profileCoordinator?.profileCoordinator.start()

        self.viewControllers = [
            mainNavigationController,
            homeNavigationController,
            installmentsNavigationController,
            partnerNavigationController,
            profileNavigationController
        ].compactMap { $0 }
    }
    
    private func configureAppTabBar() {
        
        let homeNavigationController = getNavigationController(title: NasiyaTexts.tabNames[0].localized(.olchaNasiyaModule), image: .nasiya_home_tab)
        let installmentsNavigationController = getNavigationController(title: NasiyaTexts.tabNames[1].localized(.olchaNasiyaModule), image: .nasiya_applications_tab)
        let partnerNavigationController = getNavigationController(title: NasiyaTexts.tabNames[2].localized(.olchaNasiyaModule), image: .nasiya_partners_tab)
        let profileNavigationController = getNavigationController(title: NasiyaTexts.tabNames[3].localized(.olchaNasiyaModule), image: .nasiya_profile_tab)
        
        nasiyaHomeCoordinator = NasiyaMainCoordinator(navigationController: homeNavigationController)
        nasiyaHomeCoordinator?.nasiyaHomeCoordinator.start()
        
        installmentsCoordinator = NasiyaMainCoordinator(navigationController: installmentsNavigationController)
        installmentsCoordinator?.installmentsCoordinator.start()
        
        partnerCoordinator = NasiyaMainCoordinator(navigationController: partnerNavigationController)
        partnerCoordinator?.partnerCoordinator.start()
        
        profileCoordinator = NasiyaMainCoordinator(navigationController: profileNavigationController)
        profileCoordinator?.profileCoordinator.start()

        self.viewControllers = [
            homeNavigationController,
            installmentsNavigationController,
            partnerNavigationController,
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
        ],
                                       
                                       for: .selected)
        
        tabItem.setTitleTextAttributes([
            .font: UIFont.style(.medium, 11),
            .foregroundColor: UIColor.olchaLightTextColornnnnnn],
                                       
                                       for: .normal)
        navigationController.tabBarItem = tabItem
        return navigationController
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = tabBarController.viewControllers?.firstIndex(where: { $0 == viewController })
        
        if NasiyaTab.back(index) {
            ModuleGeneratorHelper.shared.generateParent()
            return false
        }
        return true
    }
}
