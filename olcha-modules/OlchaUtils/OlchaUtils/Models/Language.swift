//
//  Language.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 09/02/23.
//

import Foundation
public enum Language: String {
    static let notification_key = "notificationLanguage"
    case oz
    case ru
    
    var localization_key: String {
        switch self {
        case .oz:
            return "en"
        case .ru:
            return "ru"
        }
    }
    
}
