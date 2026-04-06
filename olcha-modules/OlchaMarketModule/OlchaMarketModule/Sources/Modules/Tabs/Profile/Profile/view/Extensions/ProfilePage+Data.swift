//
//  ProfilePage+Data.swift
//  OlchaMarketModule
//
//  Created by ahrorxudja on 20/11/23.
//

import UIKit
import OlchaUI

extension ProfilePage {
    enum Section: String {
        case ramazan = "ramadan_times"
        case login
        case user
        case balans
        case personalData
        case myOrders
        case location
        case favourites
        case compare
        case myReviews
        case myQuestions
        case notifications
        case settings
        case logout
        case delete
        case referal
        case searchOrder
        case returnOrder
        
        case oneIdGuide

        case olchaPay
        case nasiya
        case olchaInvest
        case ecoSystem
        
        
        var image: UIImage? {
            switch self {
                case .olchaPay:
                    return .olcha_pay
                case .nasiya:
                    return .olcha_nasiya
                case .olchaInvest:
                    return .olcha_invest
                case .ecoSystem:
                    return .olcha_logo
                case .ramazan:
                    return .ramazan?.withColor(.black)
                case .personalData:
                    return .credit_datas
                case .myOrders:
                    return .orders
                case .location:
                    return .location
                case .favourites:
                    return .favourites
                case .compare:
                    return .compare
                case .myReviews:
                    return .my_reviews
                case .myQuestions:
                    return .my_questions
                case .notifications:
                    return .notifications
                case .settings:
                    return .settings
                case .logout:
                    return .logout?.withColor(.olchaAccentColor)
                case .delete:
                    return .delete_profile
                case .searchOrder:
                    return .follow_order
                case .returnOrder:
                    return .defect_return_order
                case .oneIdGuide:
                    return .resolve(named: "oneid")
                default: return nil
            }
        }
        
        var title: String {
            switch self {
                case .olchaPay:
                    return "Olcha Pay"
                case .nasiya:
                    return "Olcha Nasiya"
                case .olchaInvest:
                    return "Olcha Invest"
                case .ecoSystem:
                    return "Olcha Eco System"
                case .ramazan:
                    return "ramazan_time".localized()
                case .personalData:
                    return "termPayment".localized()
                case .myOrders:
                    return "my_orders".localized()
                case .location:
                    return "addresses".localized()
                case .favourites:
                    return "favourites".localized()
                case .compare:
                    return "compare_products".localized()
                case .myReviews:
                    return "my_reviews".localized()
                case .myQuestions:
                    return "my_questions".localized()
                case .notifications:
                    return "notifications".localized()
                case .settings:
                    return "settings".localized()
                case .logout:
                    return "logout".localized()
                case .delete:
                    return "delete_account".localized()
                case .searchOrder:
                    return "follow_order".localized()
                case .returnOrder:
                    return "return_defect_products".localized()
                case .oneIdGuide:
                    return "credit_requirement_guide".localized()
                default:
                    return ""
            }
        }
        
        var footer: CGFloat {
            switch self {
                case .user:
                    return 16
                case .balans:
                    return 0
                default:
                    return 1
            }
        }
    }
}
