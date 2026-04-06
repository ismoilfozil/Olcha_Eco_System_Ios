//
//  PassportsVerificationPage+Tooltip.swift
//  OlchaVerification
//
//  Created by Akhrorkhuja on 04/08/23.
//

import UIKit
import OlchaUI

public enum PassportsVerificationPageTooltip: Tooltip {
    case passport(in: UIView)
    case selfie(in: UIView)
    case registration(in: UIView)
    
    public static var allCases: [PassportsVerificationPageTooltip] {
        let view = UIView()
        return [
            .passport(in: view),
            .selfie(in: view),
            .registration(in: view),
        ]
    }
    
    public var prefix: String {
        return "passports_verification_page_"
    }
    
    public var key: String {
        switch self {
        case .passport:
            return "\(prefix)passport_"
        case .selfie:
            return "\(prefix)selfie_"
        case .registration:
            return "\(prefix)registration_"
        }
    }
    
    public var view: UIView {
        switch self {
        case let .passport(view), let .selfie(view), let .registration(view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        return "\(key)title".localized(.verification)
    }
    
    public var message: String {
        return "\(key)description".localized(.verification)
    }
    
    public var direction: TooltipDirection {
        switch self {
        case .passport, .selfie:
            return .up
        case .registration:
            return .down
        }
    }
}


