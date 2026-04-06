//
//  NasiyaMenuCoordinator.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/06/23.
//
import SideMenu
import UIKit
import OlchaUtils
import OlchaUI
public protocol NasiyaMenuCoordinatorProtocol: Coordinator {
    func pushFAQs()
    func pushConnection()
    func logout()
}

public class NasiyaMenuCoordinator: NasiyaMainCoordinator, NasiyaMenuCoordinatorProtocol {

    
    public override func start() {
        let menuVC: SideMenuViewController = NasiyaDIContainer.shared.resolve()
        menuVC.coordinator = self
        let menuNavigationController: SideMenuNavigationController = NasiyaDIContainer.shared.resolve(argument: menuVC)
        
        navigationController.present(menuNavigationController, animated: true)
    }
    
    public func pushFAQs() {
        profileCoordinator.pushFaqs()
    }
    
    public func pushConnection() {
        navigationController.openURL(Texts.urls.olcha_telegram)
    }
    
    public func logout() {
        navigationController.showLogout {
            NasiyaAppConfigurator.shared.appCoordinator?.logout()
        }
        
    }
    
}
