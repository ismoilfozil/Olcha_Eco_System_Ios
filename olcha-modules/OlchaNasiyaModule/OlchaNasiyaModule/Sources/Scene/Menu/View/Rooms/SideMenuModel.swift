//
//  SideMenuModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/06/23.
//

import UIKit

public enum SideMenuType: Int {
    case divide = -1
    case faq = 0
    case connection = 1
    case logout = 2
    
    
    var title: String {
        switch self {
        case .faq:
            return "most_faqs".localized(.olchaNasiyaModule)
        case .connection:
            return "connection".localized(.olchaNasiyaModule)
        case .logout:
            return "logout".localized()
        default: return ""
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .faq:
            return .faq
        case .connection:
            return .connection
        case .logout:
            return .logout
        default: return nil
        }
    }
    
    var color: UIColor {
        switch self {
        case .logout:
            return .olchaAccentColor
        default:
            return .olchaTextBlack ?? .black

        }
    }
}
