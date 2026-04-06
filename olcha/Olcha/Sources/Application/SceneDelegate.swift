//
//  SceneDelegate.swift
//  NewOlcha
//
//  Created by Muhammadjon on 1/7/21.
//

import UIKit
import ModuleGenerator
import OlchaMarketModule
import OlchaNasiyaModule
import OlchaUtils
import OlchaUI
@MainActor public protocol SceneDelegateProtocol: AnyObject {
    func getAppCoordinator() -> OlchaAppCoordinatorProtocol?
}

public class SceneDelegate: UIResponder, UIWindowSceneDelegate, SceneDelegateProtocol {
    
    public var window: UIWindow?
    
    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupParentModule()
        let rootNavigationController = BaseNavigation()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = rootNavigationController
        
        ModuleGenerator.shared.setup(navigationController: rootNavigationController)
        
        moduleObserver()
        
        ModuleGenerator.shared.generate(module: .olcha, appStarted: nil)
        
        guard let url = connectionOptions.userActivities.first?.webpageURL?.absoluteString else { return }
        
        getAppCoordinator()?.deeplinkRouter(url: url)
    }
    
    public func sceneDidDisconnect(_ scene: UIScene) { }
    
    public func sceneWillResignActive(_ scene: UIScene) { }
    
    public func sceneWillEnterForeground(_ scene: UIScene) { }
    
    public func sceneDidEnterBackground(_ scene: UIScene) {
        StorageContainer.shared.saveContext()
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    public func sceneDidBecomeActive(_ scene: UIScene) {
        guard let url = scene.userActivity?.webpageURL?.absoluteString else { return }
        getAppCoordinator()?.deeplinkRouter(url: url)
    }
    
    public func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let url = userActivity.webpageURL?.absoluteString else { return }
        getAppCoordinator()?.deeplinkRouter(url: url)
    }
    
    public func scene(_ scene: UIScene, URLContexts urlContexts: Set<UIOpenURLContext>) {
        guard let url = urlContexts.first?.url.absoluteString else { return }
        getAppCoordinator()?.deeplinkRouter(url: url)
    }
    
    public func getAppCoordinator() -> OlchaAppCoordinatorProtocol? {
        return ModuleGenerator.shared.getCurrentCoordinator()
    }
    
    private func moduleObserver() {
        ModuleGeneratorHelper.shared.moduleGenerateObserver { module, appStarted  in
            ModuleGenerator.shared.generate(module: module)
        }
    }
    
    func setupParentModule() {
        ModuleGeneratorHelper.shared.parentModule = .ecosystem
    }
}
