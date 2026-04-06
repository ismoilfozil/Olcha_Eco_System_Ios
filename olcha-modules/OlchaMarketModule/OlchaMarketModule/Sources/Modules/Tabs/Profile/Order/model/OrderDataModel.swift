//
//  OrderDataModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 21/10/22.
//

import Foundation
enum OrderDataModel {
    case type(String)
    case date(String)
    case price(String)
    case contact(String)
    case phone(String)
    case location(String)
    
    var title: String {
        switch self {
        case .type:
            return "order_type".localized()
        case .date:
            return "order_date".localized()
        case .price:
            return "order_price".localized()
        case .contact:
            return "order_contact".localized()
        case .phone:
            return "phone".localized()
        case .location:
            return "address".localized()
        }
    }
}
