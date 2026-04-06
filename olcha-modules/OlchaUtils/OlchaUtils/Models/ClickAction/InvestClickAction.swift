/// ``INVEST ACTIONS``
/// `INVEST`
/// `INVEST_ADD_INVEST`
/// `INVEST_NEWS`
/// `INVEST_NEWS_DETAIL(ACTION_ID)`
/// `INVEST_PACKAGES`
/// `INVEST_PACKAGES_DETAIL(ACTION_ID)`
/// `INVEST_PROFILE`
/// `INVEST_BALANCE(ACTION_ID)`

import Foundation

public enum InvestClickAction: ClickAction {
    case invest
    case addInvest
    case news
    case newsDetail(postId: Int?)
    case packages
    case packagesDetail(packageId: Int?)
    case profile
    case balance(balanceId: Int?)
    
    public var module: OlchaModule? {
        .invest
    }
    
    public var rawValue: String {
        switch self {
        case .invest:
            return "INVEST"
        case .addInvest:
            return "INVEST_ADD_INVEST"
        case .news:
            return "INVEST_NEWS"
        case .newsDetail:
            return "INVEST_NEWS_DETAIL"
        case .packages:
            return "INVEST_PACKAGES"
        case .packagesDetail:
            return "INVEST_PACKAGES_DETAIL"
        case .profile:
            return "INVEST_PROFILE"
        case .balance:
            return "INVEST_BALANCE"
        }
    }
    
    public static func fromRawValue(_ rawValue: String?, actionId: Int?, alias: String? = nil) -> InvestClickAction? {
        switch rawValue {
        case "INVEST":
            return .invest
        case "INVEST_ADD_INVEST":
            return .addInvest
        case "INVEST_NEWS":
            return .news
        case "INVEST_NEWS_DETAIL":
            return .newsDetail(postId: actionId)
        case "INVEST_PACKAGES":
            return .packages
        case "INVEST_PACKAGES_DETAIL":
            return .packagesDetail(packageId: actionId)
        case "INVEST_PROFILE":
            return .profile
        case "INVEST_BALANCE":
            return .balance(balanceId: actionId)
        default: return nil
        }
    }
}
