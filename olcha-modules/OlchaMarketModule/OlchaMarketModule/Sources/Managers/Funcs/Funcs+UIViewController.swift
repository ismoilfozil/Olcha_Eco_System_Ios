//
//  Funcs+UIViewController.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/11/22.
//

import UIKit
import OlchaUI
extension Funcs {
    static func openSafari(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    static func openAnorbank() {
        guard let url = URL(string: MarketTexts.urls.anorbank) else { return }
        UIApplication.shared.open(url)
    }
    
    static func openPhone() {
        guard let number = URL(string: "tel://" + "+" + MarketTexts.olcha_phone.phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    static func openTelegram() {
        guard let number = URL(string: MarketTexts.urls.telegram) else { return }
        UIApplication.shared.open(number)
    }
    
    static func openInstagram() {
        guard let number = URL(string: MarketTexts.urls.instagram) else { return }
        UIApplication.shared.open(number)
    }
    
    static func getTopViewController() -> UIViewController? {
        guard let tabBarVC = UIApplication.shared.tabController else { return nil }
        if let currentNavController = tabBarVC.selectedViewController as? UINavigationController {
            if currentNavController.presentedViewController == nil {
                return currentNavController.topViewController
            } else {
                return currentNavController.presentedViewController
            }
        }
        return nil
    }
}
