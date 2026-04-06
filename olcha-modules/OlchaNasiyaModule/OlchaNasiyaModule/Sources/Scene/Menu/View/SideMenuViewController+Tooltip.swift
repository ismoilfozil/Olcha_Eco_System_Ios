//
//  SideMenuViewController+Tooltip.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 03/08/23.
//

import UIKit
import OlchaUI

public enum SideMenuViewControllerTooltip: Tooltip {
    case faq(in: UIView)
    case support(in: UIView)
    
    public static var allCases: [SideMenuViewControllerTooltip] {
        let view = UIView()
        return [
            .faq(in: view),
            .support(in: view)
        ]
    }
    
    public var prefix: String {
        return "side_menu_view_controller_"
    }
    
    public var key: String {
        switch self {
        case .faq:
            return "\(prefix)faq_"
        case .support:
            return "\(prefix)support_"
        }
    }
    
    public var view: UIView {
        switch self {
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
        return "\(key)title".localized(.olchaNasiyaModule)
    }
    
    public var message: String {
        return "\(key)description".localized(.olchaNasiyaModule)
    }
    
    public var direction: TooltipDirection {
        switch self {
        case .faq:
            return .down
        case .support:
            return .down
        }
    }
}
