//
//  Funcs.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov

import UIKit
import OlchaUtils
import AVFoundation
import OlchaUI

class Funcs {
    
//    enum TAB: Int {
//        case home
//        case cards
//        case categories
//        case monitoring
//        case profile
//    }
//
    static func openTelegram() {
        guard let number = URL(string: Texts.urls.olcha_telegram) else { return }
        UIApplication.shared.open(number)
    }
    
    static func openInstagram() {
        guard let number = URL(string: Texts.urls.instagram) else { return }
        UIApplication.shared.open(number)
    }

    static func changeTab(_ index: Int) {
        UIApplication.shared.main?.navigationController?.tabBarController?.selectedIndex = index
        UIApplication.shared.main?.navigationController?.popToRootViewController(animated: true)
    }
 
}

//extension UIViewController {
//    func changeTab(navigationController: UINavigationController, index: Int) {
//        navigationController.tabBarController?.selectedIndex = index
//        navigationController.popToRootViewController(animated: true)
//    }
//}
