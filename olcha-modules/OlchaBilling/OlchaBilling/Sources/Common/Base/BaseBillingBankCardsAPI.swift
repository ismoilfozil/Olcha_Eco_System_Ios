//
//  BaseBankCardsAPI.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 22/06/23.
//

import Foundation
import OlchaUtils
import Alamofire
import OlchaCore
import OlchaAuth

public class BaseBillingBankCardsHeader: ApiHeader {

    public var items: HTTPHeaders
    
    init(items: HTTPHeaders) {
        self.items = items
    }
    
    public static func headers() -> BillingHeader {
        let items: HTTPHeaders = [
            "ClientModel": "ios",
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization" : AuthGlobalDefaults.getToken(),
            "Accept-Language" : String.getAppLanguage()
        ]
        
        return BillingHeader(items: items)
    }
}
