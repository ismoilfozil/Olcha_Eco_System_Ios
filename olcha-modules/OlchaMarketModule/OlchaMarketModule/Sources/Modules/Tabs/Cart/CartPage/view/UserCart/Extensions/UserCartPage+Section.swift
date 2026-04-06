//
//  CartPage+Section.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 02/02/24.
//

import UIKit
import OlchaUtils
import OlchaUI

extension UserCartPage {
    enum Section: Int {
        case products
        case profile
        case locations
        case orderType
        case paymentType
        case promocode
        case bonus
        case comment
        case emptyBonus
        case getCost
        case action
        
        var title: String {
            switch self {
            case .profile:
                return "profile".localized()
            case .locations:
                return "select_ship_address".localized()
            case .orderType:
                return "select_order_type".localized()
            case .paymentType:
                return "select_payment_type".localized()
            case .promocode:
                return "fill_promocode".localized()
            case .bonus:
                return "use_bonus".localized()
            case .comment:
                return "cart_comment".localized()
            case .emptyBonus:
                return "use_bonus".localized()
            default:
                return ""
            }
        }
        
        var header: String {
            switch self {
            case .profile:
                return "profile".localized()
            case .locations:
                return "ship_address".localized()
            case .orderType:
                return "order_type".localized()
            case .paymentType:
                return "payment_type".localized()
            case .promocode:
                return "promocode".localized()
            case .bonus:
                return "use_bonus".localized()
            case .comment:
                return "cart_comment".localized()
            case .emptyBonus:
                return "use_bonus".localized()
            default:
                return ""
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .profile:
                return .cart_profile
            case .locations:
                return .cart_locations
            case .orderType:
                return .cart_order_type
            case .paymentType:
                return .cart_payment_type
            case .promocode:
                return .cart_promocode
            case .bonus:
                return .cart_bonus
            case .comment:
                return .cart_comment
            case .emptyBonus:
                return .cart_bonus
            default:
                return nil
            }
        }
        var roundStyle: RoundStyle {
            switch self {
            case .profile:
                return .top
            case .locations:
                return .bottom
            case .orderType:
                return .top
            case .comment:
                return .bottom
            case .getCost:
                return .top
            default:
                return .middle
            }
        }
        var separatorStyle: SeparatorStyle {
            switch self {
            case .products:
                return .blockSeparator
            case .profile:
                return .separator
            case .locations:
                return .blockSeparator
            case .orderType:
                return .separator
            case .paymentType:
                return .separator
            case .promocode:
                return .separator
            case .bonus:
                return .separator
            case .emptyBonus:
                return .separator
            case .comment:
                return .blockSeparator
            case .getCost:
                return .empty
            case .action:
                return .empty
            }
        }
        
        var info: Bool {
            switch self {
            case .emptyBonus:
                return true
            default:
                return false
            }
        }
    }
    
    enum SeparatorStyle {
        case empty
        case separator
        case blockSeparator
    }
}
