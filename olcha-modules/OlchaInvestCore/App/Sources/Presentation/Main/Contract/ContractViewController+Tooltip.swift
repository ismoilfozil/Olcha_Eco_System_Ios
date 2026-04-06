//
//  ContractViewController+Tooltip.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public enum ContractViewControllerTooltip: Tooltip {
    public static var allCases: [ContractViewControllerTooltip] {
        [
            .name(in: UIView()),
            .amounts(in: UIView()),
            .withdraw(in: UIView()),
            .details(in: UIView()),
            .package(in: UIView()),
            .chart(in: UIView()),
            .history(in: UIView())
        ]
    }
    
    case name(in: UIView)
    case amounts(in: UIView)
    case withdraw(in: UIView)
    case details(in: UIView)
    case package(in: UIView)
    case chart(in: UIView)
    case history(in: UIView)
    
    public var prefix: String {
        return "ContractViewControllerTooltip_didshow_"
    }
    
    public var key: String {
        switch self {
        case .name:
            return "\(prefix)name"
        case .amounts:
            return "\(prefix)amounts"
        case .withdraw:
            return "\(prefix)withdraw"
        case .details:
            return "\(prefix)details"
        case .package:
            return "\(prefix)package"
        case .chart:
            return "\(prefix)chart"
        case .history:
            return "\(prefix)history"
        }
    }
    
    public var view: UIView {
        switch self {
        case .name(let view):
            return view
        case .amounts(let view):
            return view
        case .withdraw(let view):
            return view
        case .details(let view):
            return view
        case .package(let view):
            return view
        case .chart(let view):
            return view
        case .history(let view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        switch self {
        case .name:
            return "contract_view_controller_tooltip_name_title".localized(.olchaInvestCore)
        case .amounts:
            return "contract_view_controller_tooltip_amounts_title".localized(.olchaInvestCore)
        case .withdraw:
            return "contract_view_controller_tooltip_withdraw_title".localized(.olchaInvestCore)
        case .details:
            return "contract_view_controller_tooltip_details_title".localized(.olchaInvestCore)
        case .package:
            return "contract_view_controller_tooltip_package_title".localized(.olchaInvestCore)
        case .chart:
            return "contract_view_controller_tooltip_chart_title".localized(.olchaInvestCore)
        case .history:
            return "contract_view_controller_tooltip_history_title".localized(.olchaInvestCore)
        }
    }
    
    public var message: String {
        switch self {
        case .name:
            return "contract_view_controller_tooltip_name_description".localized(.olchaInvestCore)
        case .amounts:
            return "contract_view_controller_tooltip_amounts_description".localized(.olchaInvestCore)
        case .withdraw:
            return "contract_view_controller_tooltip_withdraw_description".localized(.olchaInvestCore)
        case .details:
            return "contract_view_controller_tooltip_details_description".localized(.olchaInvestCore)
        case .package:
            return "contract_view_controller_tooltip_package_description".localized(.olchaInvestCore)
        case .chart:
            return "contract_view_controller_tooltip_chart_description".localized(.olchaInvestCore)
        case .history:
            return "contract_view_controller_tooltip_history_description".localized(.olchaInvestCore)
        }
    }
    
    public var direction: TooltipDirection {
        switch self {
        case .name:
            return .up
        case .amounts:
            return .up
        case .withdraw:
            return .up
        case .details:
            return .up
        case .package:
            return .up
        case .chart:
            return .down
        case .history:
            return .down
        }
    }
}

