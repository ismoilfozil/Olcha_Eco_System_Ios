//
//  BaseViewController+TabBarController.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/11/22.
//

import UIKit
//extension BaseViewController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        
//        let index = tabBarController.viewControllers?.firstIndex(where: { $0 == viewController })
//        var navigationController: UINavigationController?
//        
//        if tabBarController.selectedIndex < (tabBarController.viewControllers?.count ?? 0) {
//            navigationController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? UINavigationController
//        }
//        print(" checking is user", index, GlobalDefaults.isUser(), navigationController)
//        if index == .CART_TAB_INDEX,
//           !GlobalDefaults.isUser() {
//            if let navigationController = navigationController {
//                print("present auth")
//                authCoordinator = nil
//                authCoordinator = AuthCoordinator(navigationController: navigationController)
//
//                authCoordinator?.start()
//                return false
//            }
//        }
//        return true
//    }
//    
//}
