//
//  MenuViewController+Tooltip.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public enum MenuViewControllerTooltip: Tooltip {
    public static var allCases: [MenuViewControllerTooltip] {
        [.suggestions(in: UIView()), .faq(in: UIView()), .support(in: UIView())]
    }
    
    case suggestions(in: UIView)
    case faq(in: UIView)
    case support(in: UIView)
    
    public var prefix: String {
        return "MenuViewControllerTooltip_didshow_"
    }
    
    public var key: String {
        switch self {
        case .suggestions:
            return "\(prefix)suggestions"
        case .faq:
            return "\(prefix)faq"
        case .support:
            return "\(prefix)support"
        }
    }
    
    public var view: UIView {
        switch self {
        case .suggestions(let view):
            return view
        case .faq(let view):
            return view
        case .support(let view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        switch self {
        case .suggestions:
            return "menu_view_controller_tooltip_suggestions_title".localized(.olchaInvestCore)
        case .faq:
            return "menu_view_controller_tooltip_faq_title".localized(.olchaInvestCore)
        case .support:
            return "menu_view_controller_tooltip_support_title".localized(.olchaInvestCore)
        }
    }
    
    public var message: String {
        switch self {
        case .suggestions:
            return "menu_view_controller_tooltip_suggestions_description".localized(.olchaInvestCore)
        case .faq:
            return "menu_view_controller_tooltip_faq_description".localized(.olchaInvestCore)
        case .support:
            return "menu_view_controller_tooltip_support_description".localized(.olchaInvestCore)
        }
    }
    
    public var direction: TooltipDirection {
        switch self {
        case .suggestions:
            return .down
        case .faq:
            return .down
        case .support:
            return .down
        }
    }
}
