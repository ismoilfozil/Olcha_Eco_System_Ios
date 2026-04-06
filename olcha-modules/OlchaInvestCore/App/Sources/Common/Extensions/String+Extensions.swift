//
//  String+Extensions.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public extension String {
    var cardCorrection: String {
        guard phoneNumber.count == 4 else { return "" }
        return phoneNumber[2..<4] + phoneNumber[0..<2]
    }
    
    static var investLang: Lang {
        let lang = UserDefaults(suiteName: "olcha-utils")?.string(forKey: "lang") ?? "ru"
        return Lang(rawValue: lang) ?? .ru
    }
    
    static func lang(_ ru: String?, _ uz: String?, _ oz: String?) -> String {
        switch investLang {
        case .oz: return oz ?? ""
        case .ru: return ru ?? ""
        }
    }
}
