//
//  PayTexts.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/04/23.
//

import OlchaUtils
final class PayTexts {
    static var tabNames: [String] {
        [
            
            "pay_main_tab_item",
            PayAppConfigurator.shared.isModule ? "pay_wallet_tab_item" : nil,
            "pay_cards_tab_item",
            "pay_payments_tab_item",
            "pay_monitoring_tab_item",
            PayAppConfigurator.shared.isModule ? nil : "pay_profile_tab_item"
            
        ].compactMap({ $0 })
    }
    
}
