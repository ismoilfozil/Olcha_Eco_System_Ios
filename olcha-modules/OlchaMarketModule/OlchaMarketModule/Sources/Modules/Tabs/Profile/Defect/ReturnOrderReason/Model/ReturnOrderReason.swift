//
//  ReturnOrderReason.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 19/10/23.
//

import Foundation
import OlchaUtils
enum ReturnOrderReason {
    case `return`
    case change
    case other
    
    var title: String {
        switch self {
        case .return:
            return "return_products".localized()
        case .change:
            return "change_products".localized()
        case .other:
            return "other".localized()
        }
    }
}
