//
//  EcoHomeViewController+Tooltip.swift
//  OlchaEcoSystemCore
//
//  Created by Elbek Khasanov on 14/11/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
public enum EcoHomeViewControllerTooltip: Tooltip {
    
    public static var allCases: [EcoHomeViewControllerTooltip] {
        [
            .market(in: UIView())
        ]
    }
    
    case market(in: UIView)
    
    public var prefix: String {
        return "EcoHomeViewControllerTooltip_didshow_"
    }
    
    public var key: String {
        switch self {
        case .market:
            return "\(prefix)market"
        }
    }
    
    public var view: UIView {
        switch self {
        case .market(let view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        switch self {
        case .market:
            return "OLCHA MARKET TITLE"
        }
    }
    
    public var message: String {
        switch self {
        case .market:
            return "OLCHA MARKET MESSAGE"
        }
    }
    
    public var direction: OlchaUI.TooltipDirection {
        switch self {
        case .market:
            return .up
        }
    }
    
    
}
