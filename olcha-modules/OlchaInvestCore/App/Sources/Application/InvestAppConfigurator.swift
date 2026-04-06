//
//  InvestAppConfigurator.swift
//  OlchaInvestModule
//
//  Created by Akhrorkhuja on 15/05/23.
//

import UIKit
import OlchaCommon
import OlchaUI

public class InvestAppConfigurator {
    
    public static let shared = InvestAppConfigurator()
    
    private init() {}
    
    public weak var appCoordinator: InvestAppCoordinatorProtocol?
    
    public var isModule: Bool = false
    
    public func baseConfigure() {
        UITableView.defaultBundle = .olchaInvestCore
        UINavigationController.tabless = true
        OnboardingConfigurator.configure(languages: [ .oz, .ru ],
                                         bundleType: .olchaInvestCore,
                                         application: .invest,
                                         pages: 4,
                                         is_image_localized: true
        )
        CommonConfigurator.shared.tabNames =  InvestTexts.tabNames
        CommonConfigurator.shared.bundle = .olchaInvestCore
    }
    
}

public enum AppConfiguration {
    case debug
    case testFlight
    case appStore
}

public struct Config {
    private static var isTestFlight: Bool {
        Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }
    
    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    public static var isTestFlightOrDebug: Bool {
        isTestFlight || isDebug
    }
    
    public static var appConfiguration: AppConfiguration {
        isDebug ? .debug : isTestFlight ? .testFlight : .appStore
    }
}
