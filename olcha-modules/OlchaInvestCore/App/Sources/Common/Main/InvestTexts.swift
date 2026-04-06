//
//  InvestTexts.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUtils

public class InvestTexts {
    public static var tabNames: [String] {
        [
            
            "main_tab_item",
            InvestAppConfigurator.shared.isModule ? "home_tab_item" : nil,
            "package_tab_item",
            "profile_tab_item"
            
        ].compactMap({ $0 })
    }
    
    public static let metricaKey = "75cb622a-6c52-4e95-9fed-508a22197440"
    
    public static let groupBundle = "group.com.olcha.olcha-invest.NotificationServiceExtension"
    
    public static let allNotificationsTopic = "all_ios"
}
