//
//  ApplicationConfigurator.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 26/04/23.
//

import UIKit
import OlchaUI
import OlchaUtils

public class OlchaApplicationConfigurator {
    
    public static let shared = OlchaApplicationConfigurator()
    
    public init() {}
    
    public weak var appCoordinator: OlchaAppCoordinatorProtocol?

    public var isModule: Bool = true
    
    public func baseConfiguration() {
        UITableView.defaultBundle = .olchaMarketModule
        UINavigationController.tabless = false
    }
}
