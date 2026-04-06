//
//  SortItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/10/22.
//

import Foundation
import AVFoundation
import UIKit
public protocol SortItem {
    var text: String { get }
    var key: String { get }
}

enum ProductsSortItem: String, SortItem, CaseIterable {
    case popular = "popular"
    case new = "-date"
    case old = "date"
    case expensive = "-price"
    case cheap = "price"
    case rating = "rating"
    case discountLow = "discount"
    case discountHigh = "-discount"
    case none
    
    var text: String {
        switch self {
        case .popular:
            return "popular_products".localized()
        case .new:
            return "first_new".localized()
        case .old:
            return "first_old".localized()
        case .expensive:
            return "first_expensive".localized()
        case .cheap:
            return "first_cheap".localized()
        case .rating:
            return "rating".localized()
        case .discountLow:
            return "first_minimum_discount".localized()
        case .discountHigh:
            return "first_discount".localized()
        case .none:
            return ""
        }
    }
    
    var key: String {
        switch self {
        case .popular:
            return "popular"
        case .new:
            return "-date"
        case .old:
            return "date"
        case .expensive:
            return "-price"
        case .cheap:
            return "price"
        case .rating:
            return "rating"
        case .discountLow:
            return "discount"
        case .discountHigh:
            return "-discount"
        case .none:
            return ""
        }
    }
}

enum PaymentType: String {
    case payme
    case click
    case apelsin
    case anorbank_instalment
    case none
}

enum MyOrdersSortItem: String, SortItem {
    
    
    case all
    case pending
    case paid
    case shipping
    case shipped
    case canceled
    case confirmed
    case delivered
    case in_work
    case finished
    case success
    case fail
    case packing
    case reserved
    case waiting
    case none
    
    var subtitle: String {
        switch self {
            case .pending:
                return "order_waiting_payment".localized()
            case .shipping:
                return "order_shipping_subtitle".localized()
            default: return ""
        }
    }
    
    var text: String {
        switch self {
        case .all: return "all".localized()
        case .pending: return "pending".localized()
        case .confirmed: return "confirmed".localized()
        case .paid: return "paid".localized()
        case .shipping: return "shipping".localized()
        case .delivered: return "delivered".localized()
        case .canceled: return "canceled".localized()
        default: return ""
        }
    }
    
    var key: String {
        switch self {
        case .all: return "all"
        case .pending: return "pending"
        case .confirmed: return "confirmed"
        case .paid: return "paid"
        case .shipping: return "shipping"
        case .delivered: return "delivered"
        case .canceled: return "canceled"
        default: return ""
        }
    }
    
    var color: UIColor? {
        switch self {
        case .pending:
            return .olchaGreen
        case .paid:
            return .olchaGreen
        case .shipping:
            return .olchaGreen
        case .shipped:
            return .olchaGreen
        case .canceled:
            return .olchaAccentColor
        case .confirmed:
            return .olchaGreen
        case .delivered:
            return .olchaGreen
        case .in_work:
            return .olchaGreen
        default: return .olchaTextBlack
        }
    }
}
