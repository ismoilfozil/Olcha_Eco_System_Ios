//
//  ModuleGenerator.swift
//  ModuleGenerator
//
//  Created by Elbek Khasanov on 25/04/23.
//

import UIKit
import OlchaPayModule
import OlchaMarketModule
import OlchaNasiyaModule
import OlchaInvestCore
import OlchaEcoSystemCore
import OlchaCashback
import OlchaSayohat
import OlchaUtils
import CoreData
import OlchaUI

public class ModuleGenerator {
    
    public static let shared = ModuleGenerator()
    
    var navigationController: BaseNavigation?
    
    var coordinators: [Any] = []
    
    public init() {}
    
    public func setup(navigationController: BaseNavigation = BaseNavigation()) {
        self.navigationController = navigationController
    }
    
    public func generate(module: OlchaModule, appStarted: (() -> Void)? = nil) {
        switch module {
        case .olcha:
            generateOlchaModule(appStarted: appStarted)
        case .pay:
            generatePayModule(appStarted: appStarted)
        case .nasiya:
            generateNasiyaModule(appStarted: appStarted)
        case .invest:
            generateInvestModule(appStarted: appStarted)
        case .ecosystem:
            generateEcoSystemModule()
        case .cashback:
            generateCashbackModule()
        case .sayohat:
            generateSayohatModule()
        }
    }
    
    public func getCurrentCoordinator<T>() -> T? {
        coordinators.last(where: { $0 is T }) as? T
    }
    
    deinit {
        coordinators.removeAll()
    }
    
    private func generateOlchaModule(appStarted: (() -> Void)?) {

        guard let navigationController = navigationController else {return}

        OlchaApplicationConfigurator.shared.isModule = true
        OlchaApplicationConfigurator.shared.baseConfiguration()
        
        let coordinator: OlchaAppCoordinatorProtocol = OlchaAppCoordinator(navigationController: navigationController)
        coordinator.start(appStarted: appStarted)
        coordinators.append(coordinator)
        
        OlchaApplicationConfigurator.shared.appCoordinator = coordinator
    }
    
    private func generatePayModule(appStarted: (() -> Void)?) {
        
        guard let navigationController = navigationController else {return}

        PayAppConfigurator.shared.isModule = true
        PayAppConfigurator.shared.baseConfiguration()

        let coordinator: PayAppCoordinatorProtocol = PayAppCoordinator(navigationController: navigationController)
        coordinator.start(appStarted: appStarted)
        coordinators.append(coordinator)

        PayAppConfigurator.shared.appCoordinator = coordinator
    }
    
    private func generateNasiyaModule(appStarted: (() -> Void)?) {
        
        guard let navigationController = navigationController else {return}

        NasiyaAppConfigurator.shared.isModule = true
        NasiyaAppConfigurator.shared.baseConfiguration()

        let coordinator: NasiyaAppCoordinatorProtocol = NasiyaAppCoordinator(navigationController: navigationController)
        coordinator.start(appStarted: appStarted)
        coordinators.append(coordinator)

        NasiyaAppConfigurator.shared.appCoordinator = coordinator
    }
    
    private func generateInvestModule(appStarted: (() -> Void)?) {
        guard let navigationController = navigationController else {return}
        
        InvestAppConfigurator.shared.isModule = true
        InvestAppConfigurator.shared.baseConfigure()
        
        let coordinator: InvestAppCoordinatorProtocol = InvestAppCoordinator(navigationController: navigationController)
        coordinator.start(appStarted: appStarted)
        coordinators.append(coordinator)
        
        InvestAppConfigurator.shared.appCoordinator = coordinator
    }
    
    private func generateEcoSystemModule() {
        guard let navigationController = navigationController else {return}
        
        EcoAppConfigurator.shared.isModule = false
        EcoAppConfigurator.shared.baseConfigure()
        
        let coordinator: EcoAppCoordinatorProtocol = EcoAppCoordinator(navigationController: navigationController)
        coordinator.start(appStarted: nil)
        coordinators.removeAll()
        coordinators.append(coordinator)
        
        EcoAppConfigurator.shared.appCoordinator = coordinator
    }
    
    private func generateCashbackModule() {
        guard let navigationController = navigationController else {return}
        
        let coordinator: CashbackAppCoordinatorProtocol = CashbackAppCoordinator(navigationController: navigationController)
        coordinator.start(appStarted: nil)
        coordinators.append(coordinator)
    }
    
    private func generateSayohatModule() {
        guard let navigationController = navigationController else {return}
        
        let coordinator: SayohatAppCoordinatorProtocol = SayohatAppCoordinator(navigationController: navigationController)
        coordinator.start(appStarted: nil)
        coordinators.append(coordinator)
        
        SayohatAppConfigurator.shared.appCoordinator = coordinator
    }
}
