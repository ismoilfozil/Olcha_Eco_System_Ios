//
//  PackagesViewController+Tooltip.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public enum PackagesViewControllerTooltip: Tooltip {
    public static var allCases: [PackagesViewControllerTooltip] {
        [
            .percent(in: UIView()),
            .term(in: UIView()),
            .currency(in: UIView())
        ]
    }
    
    case percent(in: UIView)
    case term(in: UIView)
    case currency(in: UIView)
    
    public var prefix: String {
        return "PackagesViewControllerTooltip_didshow_"
    }
    
    public var key: String {
        switch self {
        case .percent:
            return "\(prefix)percent"
        case .term:
            return "\(prefix)term"
        case .currency:
            return "\(prefix)currency"
        }
    }
    
    public var view: UIView {
        switch self {
        case .percent(let view):
            return view
        case .term(let view):
            return view
        case .currency(let view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        switch self {
        case .percent:
            return "packages_view_controller_percent_title".localized(.olchaInvestCore)
        case .term:
            return "packages_view_controller_term_title".localized(.olchaInvestCore)
        case .currency:
            return "packages_view_controller_currency_title".localized(.olchaInvestCore)
        }
    }
    
    public var message: String {
        switch self {
        case .percent:
            return "packages_view_controller_percent_description".localized(.olchaInvestCore)
        case .term:
            return "packages_view_controller_term_description".localized(.olchaInvestCore)
        case .currency:
            return "packages_view_controller_currency_description".localized(.olchaInvestCore)
        }
    }
    
    public var direction: TooltipDirection {
        switch self {
        case .percent:
            return .down
        case .term:
            return .down
        case .currency:
            return .down
        }
    }
}

