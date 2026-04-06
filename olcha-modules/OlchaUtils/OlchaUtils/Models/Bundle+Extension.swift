//
//  Bundle+Extension.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 20/01/23.
//

import Foundation

public enum BundleType: CaseIterable {
    case ui
    case resources
    case olchaPayModule
    case olcha
    case nasiya
    case olchaMarketModule
    case bankCards
    case olchaNasiyaModule
    case pincode
    case verification
    case olchaInvestCore
    case billing
    case olchaEcoSystemCore
    case profile
    case common
    
    public var identifier: String {
        switch self {
        case .olcha:
            return "com.olcha.ecommerce"
        case .nasiya:
            return "com.olcha.nasiya"
        case .olchaMarketModule:
            return "com.olcha.OlchaMarketModule"
        case .ui:
            return "com.olcha.OlchaUI"
        case .resources:
            return "com.olcha.OlchaResources"
        case .olchaPayModule:
            return "com.olcha.OlchaPayModule"
        case .bankCards:
            return "com.olcha.OlchaBankCards"
        case .olchaNasiyaModule:
            return "com.olcha.OlchaNasiyaModule"
        case .pincode:
            return "com.olcha.OlchaPincode"
        case .verification:
            return "com.olcha.OlchaVerification"
        case .olchaInvestCore:
            return "com.olcha-invest-core"
        case .billing:
            return "com.olcha.OlchaBilling"
        case .olchaEcoSystemCore:
            return "com.olcha.eco-system-core"
        case .profile:
            return "com.olcha.OlchaProfileModule"
        case .common:
            return "com.olcha.OlchaCommon"
        }
    }
}

public extension BundleType {
    static var allGroupNames: [String] {
        [Texts.groupUrls.invest, Texts.groupUrls.ecoSystem, Texts.groupUrls.nasiya]
    }
    var groupName: String {
        switch self {
        case .olchaInvestCore:
            return Texts.groupUrls.invest
        case .olchaEcoSystemCore:
            return Texts.groupUrls.ecoSystem
        case .olchaNasiyaModule:
            return Texts.groupUrls.nasiya
        default: return ""
        }
    }
}

public enum  BillingCollectionType: String {
    case balance
    case bank_card
}

public enum Organization: String {
    public static let key: String = "organization"
    
    case market
    case nasiya
    case invest
    case ecoSystem
    case pay
    case none
    
    public var value: String {
        switch self {
        case .market:
            return "olcha-market"
        case .nasiya:
            return "olcha-nasiya"
        case .invest:
            return "olcha-invest"
        case .ecoSystem:
            return "olcha-eco-system"
        case .pay:
            return "olcha-pay"
        default:
            return ""
        }
    }
}
