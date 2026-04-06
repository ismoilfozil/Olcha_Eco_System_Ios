//
//  AmountViewController+Tooltip.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public enum AmountViewControllerTooltip: Tooltip {
    public static var allCases: [AmountViewControllerTooltip] {
        [.amount(in: UIView())]
    }
    
    case amount(in: UIView)
    
    public var prefix: String {
        return "AmountViewController_didshow_"
    }
    
    public var key: String {
        switch self {
        case .amount:
            return "\(prefix)amount"
        }
    }
    
    public var view: UIView {
        switch self {
        case .amount(let view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        switch self {
        case .amount:
            return "amount_view_controller_amount_title".localized(.olchaInvestCore)
        }
    }
    
    public var message: String {
        switch self {
        case .amount:
            return "amount_view_controller_amount_description".localized(.olchaInvestCore)
        }
    }
    
    public var direction: TooltipDirection {
        switch self {
        case .amount:
            return .up
        }
    }
}

