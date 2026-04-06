/// ``NASIYA ACTIONS``
/// `NASIYA`
/// `NASIYA_INSTALLMENT(ACTION_ID)`
/// `NASIYA_LIMIT_CARD`
/// `NASIYA_PAY_INSTALLMENT(ACTION_ID)`
/// `NASIYA_VERIFICATION`
/// `NASIYA_CARDS`
/// `NASIYA_STORES`
/// `NASIYA_STORE`
/// `NASIYA_PROFILE`

import Foundation

public enum NasiyaClickAction: ClickAction {
    case nasiya
    case installment(installmentId: Int?)
    case limitCard
    case payInstallment(installmentId: Int?)
    case verification
    case cards
    case stores
    case store(storeId: Int?)
    case profile
    
    public var module: OlchaModule? {
        .nasiya
    }
    
    public var rawValue: String {
        switch self {
        case .nasiya:
            return "NASIYA"
        case .installment:
            return "NASIYA_INSTALLMENT"
        case .limitCard:
            return "NASIYA_LIMIT_CARD"
        case .payInstallment:
            return "NASIYA_PAY_INSTALLMENT"
        case .verification:
            return "NASIYA_VERIFICATION"
        case .cards:
            return "NASIYA_CARDS"
        case .stores:
            return "NASIYA_STORES"
        case .store:
            return "NASIYA_STORE"
        case .profile:
            return "NASIYA_PROFILE"
        }
    }
    
    public static func fromRawValue(_ rawValue: String?, actionId: Int?, alias: String? = nil) -> NasiyaClickAction? {
        switch rawValue {
        case "NASIYA":
            return .nasiya
        case "NASIYA_INSTALLMENT":
            return .installment(installmentId: actionId)
        case "NASIYA_LIMIT_CARD":
            return .limitCard
        case "NASIYA_PAY_INSTALLMENT":
            return .payInstallment(installmentId: actionId)
        case "NASIYA_VERIFICATION":
            return .verification
        case "NASIYA_CARDS":
            return .cards
        case "NASIYA_STORES":
            return .stores
        case "NASIYA_STORE":
            return .store(storeId: actionId)
        case "NASIYA_PROFILE":
            return .profile
        default: return nil
        }
    }
}
