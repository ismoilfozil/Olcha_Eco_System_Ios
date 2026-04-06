//
//  SelectTermViewController+Tooltip.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public enum SelectTermViewControllerTooltip: Tooltip {
    public static var allCases: [SelectTermViewControllerTooltip] {
        [.term(in: UIView())]
    }
    
    case term(in: UIView)
    
    public var prefix: String {
        return "SelectTermViewController_didshow_"
    }
    
    public var key: String {
        switch self {
        case .term:
            return "\(prefix)term"
        }
    }
    
    public var view: UIView {
        switch self {
        case .term(let view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        switch self {
        case .term:
            return "select_term_view_controller_term_title".localized(.olchaInvestCore)
        }
    }
    
    public var message: String {
        switch self {
        case .term:
            return "select_term_view_controller_term_description".localized(.olchaInvestCore)
        }
    }
    
    public var direction: TooltipDirection {
        switch self {
        case .term:
            return .up
        }
    }
}
