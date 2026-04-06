//
//  ProfileViewController+Tooltip.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public enum ProfileViewControllerTooltip: Tooltip {
    case balance(in: UIView)
    case phoneDetails(in: UIView)
    case cardDetails(in: UIView)
    case passportDetails(in: UIView)
    case security(in: UIView)
    
    public static var allCases: [ProfileViewControllerTooltip] {
        let view = UIView()
        return [
            .balance(in: view), .phoneDetails(in: view),
            .cardDetails(in: view), .passportDetails(in: view),
            .security(in: view)
        ]
    }
    
    public var prefix: String {
        return "ProfileViewControllerTooltip_didshow_"
    }
    
    public var key: String {
        switch self {
        case .balance:
            return "\(prefix)suggestions"
        case .phoneDetails:
            return "\(prefix)phone_details"
        case .cardDetails:
            return "\(prefix)card_details"
        case .passportDetails:
            return "\(prefix)passport_details"
        case .security:
            return "\(prefix)security"
        }
    }
    
    public var view: UIView {
        switch self {
        case .balance(let view), .phoneDetails(let view), .cardDetails(let view):
            return view
        case .passportDetails(let view), .security(let view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        switch self {
        case .balance:
            return "profile_view_controller_tooltip_balance_title".localized(.olchaInvestCore)
        case .phoneDetails:
            return "profile_view_controller_tooltip_phone_details_title".localized(.olchaInvestCore)
        case .cardDetails:
            return "profile_view_controller_tooltip_card_details_title".localized(.olchaInvestCore)
        case .passportDetails:
            return "profile_view_controller_tooltip_passport_details_title".localized(.olchaInvestCore)
        case .security:
            return "profile_view_controller_tooltip_security_title".localized(.olchaInvestCore)
        }
    }
    
    public var message: String {
        switch self {
        case .balance:
            return "profile_view_controller_tooltip_balance_description".localized(.olchaInvestCore)
        case .phoneDetails:
            return "profile_view_controller_tooltip_phoneDetails_description".localized(.olchaInvestCore)
        case .cardDetails:
            return "profile_view_controller_tooltip_cardDetails_description".localized(.olchaInvestCore)
        case .passportDetails:
            return "profile_view_controller_tooltip_passportDetails_description".localized(.olchaInvestCore)
        case .security:
            return "profile_view_controller_tooltip_security_description".localized(.olchaInvestCore)
        }
    }
    
    public var direction: TooltipDirection {
        switch self {
        case .balance:
            return .up
        case .phoneDetails, .cardDetails, .passportDetails, .security:
            return .down
        }
    }
}
