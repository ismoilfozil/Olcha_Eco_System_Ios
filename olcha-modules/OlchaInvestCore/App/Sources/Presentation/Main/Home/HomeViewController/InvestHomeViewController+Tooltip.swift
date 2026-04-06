//
//  InvestHomeViewController+Tooltip.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 07/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public enum InvestHomeViewControllerTooltip: Tooltip {
    public static var allCases: [InvestHomeViewControllerTooltip] {
        [
            .investButton(in: UIView()),
            .packagesTabItem(in: UIView()),
            .profileTabItem(in: UIView()),
            .notificationButton(in: UIView()),
            .menuButton(in: UIView())
        ]
    }
    
    case investButton(in: UIView)
    case packagesTabItem(in: UIView)
    case profileTabItem(in: UIView)
    case notificationButton(in: UIView)
    case menuButton(in: UIView)
    
    public var prefix: String {
        return "InvestHomeViewControllerTooltip_didshow_"
    }
    
    public var key: String {
        switch self {
        case .investButton:
            return "\(prefix)investButton"
        case .packagesTabItem:
            return "\(prefix)packages_tab_item"
        case .profileTabItem:
            return "\(prefix)profile_tab_item"
        case .notificationButton:
            return "\(prefix)invest_button"
        case .menuButton:
            return "\(prefix)menu_button"
        }
    }
    
    public var view: UIView {
        switch self {
        case .investButton(let view):
            return view
        case .packagesTabItem(let view):
            return view
        case .profileTabItem(let view):
            return view
        case .notificationButton(let view):
            return view
        case .menuButton(let view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        switch self {
        case .investButton:
            return "invest_home_view_controller_investButton_title".localized(.olchaInvestCore)
        case .packagesTabItem:
            return "invest_home_view_controller_packagesTabItem_title".localized(.olchaInvestCore)
        case .profileTabItem:
            return "invest_home_view_controller_profileTabItem_title".localized(.olchaInvestCore)
        case .notificationButton:
            return "invest_home_view_controller_notificationButton_title".localized(.olchaInvestCore)
        case .menuButton:
            return "invest_home_view_controller_menuButton_title".localized(.olchaInvestCore)
        }
    }
    
    public var message: String {
        switch self {
        case .investButton:
            return "invest_home_view_controller_investButton_description".localized(.olchaInvestCore)
        case .packagesTabItem:
            return "invest_home_view_controller_packagesTabItem_description".localized(.olchaInvestCore)
        case .profileTabItem:
            return "invest_home_view_controller_profileTabItem_description".localized(.olchaInvestCore)
        case .notificationButton:
            return "invest_home_view_controller_notificationButton_description".localized(.olchaInvestCore)
        case .menuButton:
            return "invest_home_view_controller_menuButton_description".localized(.olchaInvestCore)
        }
    }
    
    public var direction: TooltipDirection {
        switch self {
        case .investButton:
            return .up
        case .packagesTabItem:
            return .down
        case .profileTabItem:
            return .down
        case .notificationButton:
            return .right
        case .menuButton:
            return .left
        }
    }
}
