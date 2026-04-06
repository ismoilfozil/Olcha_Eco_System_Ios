//
//  PayApplicationConfigurator.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/04/23.
//

import UIKit
import OlchaUtils
import OlchaAuth
import OlchaUI
import OlchaPincode
import OlchaCommon
public class PayAppConfigurator {
    public static let shared = PayAppConfigurator()
    
    public init() {
    }
    
    public weak var appCoordinator: PayAppCoordinatorProtocol?
    
    public var isModule: Bool = true
    
    public func baseConfiguration() {
        PincodeModuleConfigurator.shared.navigationBarEnabled = isModule
        CommonConfigurator.shared.tabNames =  PayTexts.tabNames
        CommonConfigurator.shared.bundle = .resources
    }
    
    public func tabConfigurations() {
        UINavigationController.tabless = true
    }
}
