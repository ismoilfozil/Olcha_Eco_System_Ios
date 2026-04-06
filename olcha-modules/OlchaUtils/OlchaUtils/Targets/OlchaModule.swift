//
//  OlchaModule.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 26/04/23.
//

import Foundation
///
/// - Modules for Olcha. If you add new application to ecosystem, you need append new case
///
public enum OlchaModule: String {
    case olcha
    case pay
    case nasiya
    case invest
    case sayohat
    case ecosystem
    case cashback
}
///
/// - ``ModuleGeneratorHelper`` is in order to generate modules
///
public class ModuleGeneratorHelper {
    
    nonisolated(unsafe) public static let shared = ModuleGeneratorHelper()
    public var parentModule: OlchaModule = .olcha
    
    private var observer: ((OlchaModule, (() -> Void)?) -> Void)?
    private var coordinatorObserver: ((OlchaModule) -> AnyObject?)?
    private var actionObserver: ((ClickAction) -> Void)?
    
    public init() {}
    
    public func moduleGenerateObserver(_ observer: ((OlchaModule, (() -> Void)?) -> Void)?) {
        self.observer = observer
    }
    
    public func moduleCoordinatorObserver(_ observer: ((OlchaModule) -> AnyObject?)?) {
        self.coordinatorObserver = observer
    }
    
    public func actionObserver(_ observer: ((ClickAction) -> Void)?) {
        self.actionObserver = observer
    }
    
    public func getModuleCoordinator<T>(module: OlchaModule) -> T? {
        self.coordinatorObserver?(module) as? T
    }
    
    public func performAction(action: ClickAction) {
        self.actionObserver?(action)
    }
    
    public func generate(module: OlchaModule, appStarted: (() -> Void)?) {
        self.observer?(module, appStarted)
    }
    
    public func generateParent() {
        self.observer?(ModuleGeneratorHelper.shared.parentModule, nil)
    }
}
