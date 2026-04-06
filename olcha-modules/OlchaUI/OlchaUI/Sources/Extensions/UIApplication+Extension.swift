//
//  UIApplication+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 22/09/22.
//


import UIKit

public extension UIApplication {
    var bottomInset: CGFloat {
        windows.first?.safeAreaInsets.bottom ?? 0
    }
    
    var topInset: CGFloat {
        windows.first?.safeAreaInsets.top ?? 0
    }
    
    var main: UIViewController? {
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        
        if let tabController = rootController as? UITabBarController,
           let navigationController = tabController.selectedViewController as? UINavigationController {
            return navigationController.topViewController
        }
        
        if let navigationController = rootController as? UINavigationController {
            if let tabBarController = navigationController.topViewController as? UITabBarController,
               let selectedNavigationController = tabBarController.selectedViewController as? UINavigationController {
                return selectedNavigationController.topViewController
            }
            return navigationController.topViewController
        }
        
        if let viewController = rootController as? UIViewController {
            return viewController
        }
        
        
        return rootController
    }
    
    var rootNavigationController: UINavigationController? {
        return UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
    }
    
    var tabController: UITabBarController? {
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        
        if let tabController = rootController as? UITabBarController {
            return tabController
        }
        
        if let navigationController = rootController as? UINavigationController,
           let topController = navigationController.topViewController,
           let tabController = topController as? UITabBarController {
            return tabController
        }
        
        if let navigationController = rootController as? UINavigationController,
           let topController = navigationController.topViewController,
           let tabController = topController.tabBarController {
            return tabController
        }
        
        return nil
    }
}
