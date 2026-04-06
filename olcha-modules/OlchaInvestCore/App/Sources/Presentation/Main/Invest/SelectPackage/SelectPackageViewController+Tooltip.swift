//
//  SelectPackageViewController+Tooltip.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public enum SelectPackageViewControllerTooltip: Tooltip {
    public static var allCases: [SelectPackageViewControllerTooltip] {
        [.selectButton(in: UIView())]
    }
    
    case selectButton(in: UIView)
    
    public var prefix: String {
        return "SelectPackageViewControllerTooltip_didshow_"
    }
    
    public var key: String {
        switch self {
        case .selectButton:
            return "\(prefix)selectButton"
        }
    }
    
    public var view: UIView {
        switch self {
        case .selectButton(let view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        switch self {
        case .selectButton:
            return "select_package_view_controller_selectButton_title".localized(.olchaInvestCore)
        }
    }
    
    public var message: String {
        switch self {
        case .selectButton:
            return "select_package_view_controller_selectButton_description".localized(.olchaInvestCore)
        }
    }
    
    public var direction: TooltipDirection {
        switch self {
        case .selectButton:
            return .up
        }
    }
}
