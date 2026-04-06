//
//  NasiyaTexts.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import OlchaUI
import OlchaUtils
public class NasiyaTexts {
    
    public static var app_version: String {
        Bundle.main.releaseVersionNumber ?? ""
    }
    
    public static let groupBundle = "group.com.ecommerce.olcha-nasiya"
    
    struct urls {
        static let appstore = "https://apps.apple.com/uz/app/olcha/id1551492785"
    }
    
    public static var tabNames: [String] {
        [
            "main_tab_item",
            NasiyaAppConfigurator.shared.isModule ? "home_tab_item" : nil,
            "my_applications_tab_item",
            "partners_tab_item",
            "profile_tab_item"
        ].compactMap({ $0 })
    }
}
