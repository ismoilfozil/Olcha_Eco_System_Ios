//
//  NasiyaAppConfigurator.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import OlchaUI
import SideMenu
import OlchaPincode
import OlchaCommon
public class NasiyaAppConfigurator {
    public static let shared = NasiyaAppConfigurator()
    
    public init() {}
    
    public weak var appCoordinator: NasiyaAppCoordinatorProtocol?
    
    public var isModule: Bool = false
    
    public func baseConfiguration() {
        PincodeModuleConfigurator.shared.navigationBarEnabled = isModule
        UITableView.defaultBundle = .olchaNasiyaModule
        UINavigationController.tabless = true
        
        OnboardingConfigurator.configure(languages: [ .oz, .ru ],
                                         bundleType: .olchaNasiyaModule,
                                         application: .nasiya,
                                         pages: 4)
        
        CommonConfigurator.shared.tabNames =  NasiyaTexts.tabNames
        CommonConfigurator.shared.bundle = .olchaNasiyaModule
    }
}
