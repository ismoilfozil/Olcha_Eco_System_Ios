//
//  DeeplinkRouter.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 11/04/23.
//

import Foundation

enum DeeplinkType {
    case payment(helper: MakePaymentHelper)
    case news(id: Int)
    case notification(id: Int)
    case none
}

class DeeplinkRouter {
    
     
    static func checkDeeplinkType(urlString: String?) -> DeeplinkType {
        guard let urlString = urlString,
              let url = URL(string: urlString),
              let components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false)
        else {
            return .none
        }
        
        if urlString.contains("payment/"),
            let queryItems = components.queryItems {
            
            let makePaymentHelper = MakePaymentHelper()
            
            for item in queryItems {
                
                if item.name == "service_id" {
                    
                    if let serviceID = item.value?.int {
                        makePaymentHelper.serviceID = serviceID
                    }
                    
                } else if item.name == "provider_id" {
                    
                    if let providerID = item.value?.int {
                        makePaymentHelper.providerID = providerID
                    }
                    
                } else {
                    
                    makePaymentHelper.filledFields.append(.init(key: item.name,
                                                                value: item.value,
                                                                is_money: nil,
                                                                type: nil))
                    
                }
            }
            
            return .payment(helper: makePaymentHelper)
        }
            
        return .none
    }
}
