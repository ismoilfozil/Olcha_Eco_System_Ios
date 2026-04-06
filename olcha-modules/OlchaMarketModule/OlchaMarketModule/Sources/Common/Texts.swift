//
//  Texts.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import Foundation
import OlchaUtils
import OlchaCore

class MarketTexts {
    
    static let status_ok = "ok"
    
    static let anorbankCreditCards: [String] = [
        "98606003",
        "98606066",
        "98606068",
        "98606069"
    ]
    
//    static var tabNames: [String] {
//        [
//            OlchaApplicationConfigurator.shared.isModule ? "back".localized() : nil,
//            "main".localized(),
//            "catalog".localized(),
//            "basket".localized(),
//            OlchaApplicationConfigurator.shared.isModule ? nil : "favourite".localized(),
//            "profile".localized(),
//        ].compactMap { $0 }
//    }
    
    static var currency: String {
        get {
            return "currency".localized()
        }
    }
    
    static let ok = "ok"
    
    static let animation_success = "success"
    
    static var seeAll: String {
        "see_all".localized()
    }
    
    static var cash : String {
        get {
            "cash".localized()
        }
    }
    
    static let client_ID = "6"
    static let client_secret = "RnfliHduJAdJ5bcmDOp63WDu0uMjA0ZPYvirCnHD"
    static let refresh_token = "refresh_token"
    static let password = "password"
    static let client_credentials = "client_credentials"
    
    static var deleteSubmitTitle : String {
        get {
            "really_delete".localized()
        }
    }
    
    static let TASHKENT_ID = 1
    
    static var fail : String {
        get {
            "error_text".localized()
        }
    }
    
}
//MARK: - App Texts
extension MarketTexts {
    static var app_version: String {
        Bundle.main.releaseVersionNumber ?? ""
    }
    
    static let olcha_phone = "+998(71)-202-202-1"
    
    struct urls {
        static let anorbank = "itms-apps://itunes.apple.com/app/id1579623268"
        static let telegram = "https://telegram.me/olcha_support"
        static let instagram = "https://www.instagram.com/olcha_uz/"
        static let offer = "https://olcha.uz/lang/page/public-offer"
        static let appstore = "https://apps.apple.com/uz/app/olcha/id1551492785"
    }
    
    struct sort {
        static let myOrders : [MyOrdersSortItem] = [
            .all,
            .pending,
            .confirmed,
            .paid,
            .shipping,
            .delivered,
            .canceled
        ]
        
        static let products : [ProductsSortItem] = [
            .popular,
            .new,
            .old,
            .expensive,
            .cheap,
            .rating,
            .discountLow,
            .discountHigh
        ]
        
        
        static func fillSteps(to sortItem: MyOrdersSortItem) -> [OrderStatusItem] {
            let orderSteps : [MyOrdersSortItem] = [
                .canceled,
                .pending,
                .confirmed,
                .shipping,
                .delivered
            ]
            
            var newStatuses: [OrderStatusItem] = []
            
            guard let index = orderSteps.firstIndex(where: { $0 == sortItem }) else { return [] }
            
            for i in 0..<orderSteps.count {
                let step = orderSteps[i]
                
                    let status = OrderStatusItem(status: step.key,
                                                 subtitle: step.subtitle,
                                                 text: step.text,
                                                 active: i <= index)
                if step == .canceled {
                    if sortItem == .canceled {
                        newStatuses.append(status)
                    }
                } else {
                    newStatuses.append(status)
                }
                
            }
            return newStatuses
        }
    }
}
