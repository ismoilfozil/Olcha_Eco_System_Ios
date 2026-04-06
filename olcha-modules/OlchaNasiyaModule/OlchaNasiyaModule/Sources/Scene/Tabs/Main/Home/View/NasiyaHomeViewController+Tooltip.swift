//
//  NasiyaHomeViewController+Tooltip.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 03/08/23.
//

import UIKit
import OlchaUI

public enum NasiyaHomeViewControllerTooltip: Tooltip {
    case resetButton(in: UIView)
    case menuButton(in: UIView)
    case notificationButton(in: UIView)
    case verifyButton(in: UIView)
    
    public static var allCases: [NasiyaHomeViewControllerTooltip] {
        let view = UIView()
        return [
            .resetButton(in: view),
            .menuButton(in: view),
            .notificationButton(in: view),
            .verifyButton(in: view),
        ]
    }
    
    public var prefix: String {
        return "nasiya_home_view_controller_"
    }
    
    public var key: String {
        switch self {
        case .resetButton:
            return "\(prefix)reset_button_"
        case .menuButton:
            return "\(prefix)menu_button_"
        case .notificationButton:
            return "\(prefix)notification_button_"
        case .verifyButton:
            return "\(prefix)verify_button_"
        }
    }
    
    public var view: UIView {
        switch self {
        case .resetButton(let view):
            return view
        case .menuButton(let view):
            return view
        case .notificationButton(let view):
            return view
        case .verifyButton(let view):
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
        case .resetButton:
            return .up
        case .menuButton:
            return .left
        case .notificationButton:
            return .right
        case .verifyButton:
            return .down
        }
    }
}
