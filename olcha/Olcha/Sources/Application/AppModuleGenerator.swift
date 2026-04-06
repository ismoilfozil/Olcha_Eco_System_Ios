//
//  ModuleGenerator.swift
//  ModuleGenerator
//
//  Created by Elbek Khasanov on 25/04/23.
//
//import UIKit
//import OlchaPayModule
//import OlchaMarketModule
//public enum OlchaModule {
//    case olcha
//    case pay
//}
//
//public protocol AppModuleGeneratorProtocol: AnyObject {
//    func launchOlcha()
//    func launchPay()
//}
//
//public extension AppModuleGeneratorProtocol {
//    func launchOlcha() {
//        
//    }
//    
//    func launchPay() {
//        
//    }
//}
//
//public class AppModuleGenerator {
//    
//    var window: UIWindow
//    
//    var coordinators: [Any] = []
//    
//    public init(window: UIWindow) {
//        self.window = window
//    }
//    
//    public func generate(module: OlchaModule) {
//        switch module {
//        case .olcha:
//            let coordinator: OlchaAppCoordinatorProtocol = OlchaAppCoordinator(navigationController: )
//            coordinator.start()
//            coordinators.append(coordinator)
//            break
//        case .pay:
//            let coordinator: PayAppCoordinatorProtocol = PayAppCoordinator(navigationController: window)
//            coordinator.start()
//            coordinators.append(coordinator)
//            break
//        }
//    }
//    
//    public func getCurrentCoordinator() -> Any? {
//        self.coordinators.last
//    }
//    
//    deinit {
//        coordinators.removeAll()
//    }
//}
