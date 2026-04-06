//
//  InvestViewController+Tooltip.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public enum InvestViewControllerTooltip: Tooltip {
    public static var allCases: [InvestViewControllerTooltip] {
        [
            .name(in: UIView()),
            .package(in: UIView()),
            .term(in: UIView()),
            .percent(in: UIView()),
            .amount(in: UIView()),
            .preview(in: UIView())
        ]
    }
    
    case name(in: UIView)
    case package(in: UIView)
    case term(in: UIView)
    case percent(in: UIView)
    case amount(in: UIView)
    case preview(in: UIView)
    
    public var prefix: String {
        return "InvestViewControllerTooltip_didshow_"
    }
    
    public var key: String {
        switch self {
        case .name:
            return "\(prefix)name"
        case .package:
            return "\(prefix)package"
        case .term:
            return "\(prefix)term"
        case .percent:
            return "\(prefix)percent"
        case .amount:
            return "\(prefix)amount"
        case .preview:
            return "\(prefix)preview"
        }
    }
    
    public var view: UIView {
        switch self {
        case .name(let view):
            return view
        case .package(let view):
            return view
        case .term(let view):
            return view
        case .percent(let view):
            return view
        case .amount(let view):
            return view
        case .preview(let view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        switch self {
        case .name:
            return "invest_view_controller_name_title".localized(.olchaInvestCore)
        case .package:
            return "invest_view_controller_package_title".localized(.olchaInvestCore)
        case .term:
            return "invest_view_controller_term_title".localized(.olchaInvestCore)
        case .percent:
            return "invest_view_controller_percent_title".localized(.olchaInvestCore)
        case .amount:
            return "invest_view_controller_amount_title".localized(.olchaInvestCore)
        case .preview:
            return "invest_view_controller_preview_title".localized(.olchaInvestCore)
        }
    }
    
    public var message: String {
        switch self {
        case .name:
            return "invest_view_controller_name_description".localized(.olchaInvestCore)
        case .package:
            return "invest_view_controller_package_description".localized(.olchaInvestCore)
        case .term:
            return "invest_view_controller_term_description".localized(.olchaInvestCore)
        case .percent:
            return "invest_view_controller_percent_description".localized(.olchaInvestCore)
        case .amount:
            return "invest_view_controller_amount_description".localized(.olchaInvestCore)
        case .preview:
            return "invest_view_controller_preview_description".localized(.olchaInvestCore)
        }
    }
    
    public var direction: TooltipDirection {
        switch self {
        case .name:
            return .up
        case .package:
            return .up
        case .term:
            return .up
        case .percent:
            return .up
        case .amount:
            return .down
        case .preview:
            return .down
        }
    }
}
