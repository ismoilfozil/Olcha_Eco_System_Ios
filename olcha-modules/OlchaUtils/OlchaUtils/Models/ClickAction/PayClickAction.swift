/// ``PAY ACTIONS``
/// `PAY`
/// `PAY_CATEGORIES`
/// `PAY_CATEGORY(ACTION_ID)`
/// `PAY_PROVIDER(ACTION_ID)`
/// `PAY_CARDS`

import Foundation

public enum PayClickAction: ClickAction {
    case pay
    case categories
    case category(categoryId: Int?)
    case provider(providerId: Int?)
    case cards
    
    public var module: OlchaModule? {
        .pay
    }
    
    public var rawValue: String {
        switch self {
        case .pay:
            return "PAY"
        case .categories:
            return "PAY_CATEGORIES"
        case .category:
            return "PAY_CATEGORY"
        case .provider:
            return "PAY_PROVIDER"
        case .cards:
            return "PAY_CARDS"
        }
    }
    
    public static func fromRawValue(_ rawValue: String?, actionId: Int?, alias: String? = nil) -> PayClickAction? {
        switch rawValue {
        case "PAY":
            return .pay
        case "PAY_CATEGORIES":
            return .categories
        case "PAY_CATEGORY":
            return .category(categoryId: actionId)
        case "PAY_PROVIDER":
            return .provider(providerId: actionId)
        case "PAY_CARDS":
            return .cards
        default: return nil
        }
    }
}
