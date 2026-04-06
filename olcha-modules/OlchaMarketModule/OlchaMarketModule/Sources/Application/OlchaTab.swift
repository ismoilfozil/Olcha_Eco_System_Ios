//
//  OlchaTab.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 06/10/23.
//

import UIKit
import OlchaUtils

public class OlchaTab {
    private static let extra_tabs = OlchaApplicationConfigurator.shared.isModule ? 1 : 0
    
    public static let home = extra_tabs + 0
    public static let catalog = extra_tabs + 1
    public static let cart = extra_tabs + 2
    public static let favourites = 3
    public static let profile = 4
    
    public static func back(_ index: Int?) -> Bool {
        OlchaApplicationConfigurator.shared.isModule && (index == 0)
    }

    public static var badgeTab: Int {
        OlchaApplicationConfigurator.shared.isModule ? profile : favourites
    }
    
    public static var tabs: [Tab] {
        OlchaApplicationConfigurator.shared.isModule ? [ .back, .market, .catalog, .cart, .profile] : [ .home, .catalog, .cart, .favourite, .profile]
    }
    
    func index(at tab: Tab) -> Int {
        switch tab {
        case .back:
            return 0
        case .home:
            return OlchaApplicationConfigurator.shared.isModule ? 1 : 0
        case .market:
            return OlchaApplicationConfigurator.shared.isModule ? 1 : 0
        case .catalog:
            return OlchaApplicationConfigurator.shared.isModule ? 2 : 1
        case .cart:
            return OlchaApplicationConfigurator.shared.isModule ? 3 : 2
        case .favourite:
            return OlchaApplicationConfigurator.shared.isModule ? 4 : 3
        case .profile:
            return 4
        }
    }
}

public enum Tab {
    case back
    case home
    case market
    case catalog
    case cart
    case favourite
    case profile
    
    static var mainTab: Tab {
        ModuleGeneratorHelper.shared.parentModule == .olcha ? .home : .market
    }
    
    var title: String {
        switch self {
        case .back:
            return "main".localized()
        case .home:
            return "main".localized()
        case .market:
            return "Market"
        case .catalog:
            return "catalog".localized()
        case .cart:
            return "basket".localized()
        case .favourite:
            return "favourite".localized()
        case .profile:
            return "profile".localized()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .back:
            return .eco_olcha
        case .home:
            return .tab_home
        case .market:
            return .tab_home
        case .catalog:
            return .tab_catalog
        case .cart:
            return .tab_cart
        case .favourite:
            return .tab_favourite
        case .profile:
            return .tab_profile
        }
    }
    
    var isVisible: Bool {
        switch self {
        case .back:
            return OlchaApplicationConfigurator.shared.isModule
        case .favourite:
            return !OlchaApplicationConfigurator.shared.isModule
        default:
            return true
        }
    }
}
