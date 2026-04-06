/// `MARKET ACTIONS`
/// ``MARKET``
/// ``MARKET_CATEGORY(ACTION_ID)``
/// ``MARKET_MANUFACTURER(ALIAS)``
/// ``MARKET_PRODUCT(ACTION_ID)``
/// ``MARKET_ORDERS``
/// ``MARKET_ORDER``
/// ``MARKET_FAVORITES``
/// ``MARKET_COMMENTS``
/// ``MARKET_COMPARE``
/// ``MARKET_QUESTIONS``
/// ``MARKET_ADDRESSES``
/// ``MARKET_PERSONAL_DATA``
/// ``MARKET_PROFILE_BALANCE``
/// ``MARKET_PROFILE_BONUS``
/// ``MARKET_CATALOG``
/// ``MARKET_ORDER_RETURN``
/// ``MARKET_SELLER(ACTION_ID)``

import Foundation

public enum MarketClickAction: ClickAction {
    case market
    case category(categoryId: Int?)
    case brand(brandId: Int?)
    case product(productId: Int?)
    case orders
    case order(orderId: Int?)
    case favorites
    case comments
    case compare
    case questions
    case addresses
    case personalData
    case profileBalance
    case profileBonus
    case cart
    case catalog
    case orderReturn
    case seller(sellerId: Int?)
    
    public var module: OlchaModule? {
        .olcha
    }
    
    public var rawValue: String {
        switch self {
        case .market:
            return "MARKET"
        case .category:
            return "MARKET_CATEGORY"
        case .brand:
            return "MARKET_MANUFACTURER"
        case .product:
            return "MARKET_PRODUCT"
        case .orders:
            return "MARKET_ORDERS"
        case .favorites:
            return "MARKET_FAVORITES"
        case .comments:
            return "MARKET_COMMENTS"
        case .compare:
            return "MARKET_COMPARE"
        case .questions:
            return "MARKET_QUESTIONS"
        case .addresses:
            return "MARKET_ADDRESSES"
        case .personalData:
            return "MARKET_PERSONAL_DATA"
        case .profileBonus:
            return "MARKET_PROFILE_BONUS"
        case .profileBalance:
            return "MARKET_PROFILE_BALANCE"
        case .cart:
            return "MARKET_CART"
        case .catalog:
            return "MARKET_CATALOG"
        case .orderReturn:
            return "MARKET_ORDER_RETURN"
        case .seller:
            return "MARKET_SELLER"
        case .order:
            return "MARKET_ORDER"
        }
    }
    
    public static func fromRawValue(_ rawValue: String?, actionId: Int?, alias: String? = nil) -> MarketClickAction? {
        switch rawValue {
        case "MARKET":
            return .market
        case "MARKET_CATEGORY":
            return .category(categoryId: actionId)
        case "MARKET_MANUFACTURER":
            return .brand(brandId: actionId)
        case "MARKET_PRODUCT":
            return .product(productId: actionId)
        case "MARKET_ORDERS":
            return .orders
        case "MARKET_ORDER":
            return .order(orderId: actionId)
        case "MARKET_FAVORITES":
            return .favorites
        case "MARKET_COMMENTS":
            return .comments
        case "MARKET_COMPARE":
            return .compare
        case "MARKET_QUESTIONS":
            return .questions
        case "MARKET_ADDRESSES":
            return .addresses
        case "MARKET_PERSONAL_DATA":
            return .personalData
        case "MARKET_PROFILE_BONUS":
            return .profileBonus
        case "MARKET_PROFILE_BALANCE":
            return .profileBalance
        case "MARKET_CART":
            return .cart
        case "MARKET_CATALOG":
            return .catalog
        case "MARKET_ORDER_RETURN":
            return .orderReturn
        case "MARKET_SELLER":
            return .seller(sellerId: actionId)
        default: return nil
        }
    }
}
