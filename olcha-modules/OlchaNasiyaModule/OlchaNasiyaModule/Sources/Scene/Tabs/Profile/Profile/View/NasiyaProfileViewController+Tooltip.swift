//
//  NasiyaProfileViewController+Tooltip.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 07/08/23.
//

import UIKit
import OlchaUI

public enum NasiyaProfileViewControllerTooltip: Tooltip {
    case verification(in: UIView)
    case phoneNumbers(in: UIView)
    case bankCards(in: UIView)
    case passport(in: UIView)
    case pincode(in: UIView)
    
    public static var allCases: [NasiyaProfileViewControllerTooltip] {
        let view = UIView()
        return [
            .verification(in: view),
            .phoneNumbers(in: view),
            .bankCards(in: view),
            .passport(in: view),
            .pincode(in: view),
        ]
    }
    
    public var prefix: String {
        return "nasiya_profile_view_controller_"
    }
    
    public var key: String {
        switch self {
        case .verification:
            return "\(prefix)verification_"
        case .phoneNumbers:
            return "\(prefix)phone_numbers_"
        case .bankCards:
            return "\(prefix)bank_cards_"
        case .passport:
            return "\(prefix)passport_"
        case .pincode:
            return "\(prefix)pincode_"
        }
    }
    
    public var view: UIView {
        switch self {
        case let .verification(view),
            let .phoneNumbers(view),
            let .bankCards(view),
            let .passport(view),
            let .pincode(view):
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
        case .verification, .phoneNumbers:
            return .up
        case .bankCards, .passport, .pincode:
            return .down
        }
    }
}


