//
//  AppLanguage.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 01/05/23.
//

import Foundation

public extension String {
    static let ru = "ru"
    static let oz = "oz"
    nonisolated(unsafe) static let utilsDefaults = UserDefaults(suiteName: "olcha-utils")
    nonisolated(unsafe) static let ecoGroupDefaults = UserDefaults(suiteName: Texts.groupUrls.ecoSystem)
    
    ///
    /// Before changing localized method make sure you have `checked performance on time profiler`.
    /// `it's used very often.`
    ///
    func localized(_ bundle: BundleType = .resources) -> String {
        guard let localizationBundle = LocalizationBundle.bundles[bundle] else {
            return self
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: localizationBundle, value: "", comment: "")
    }
    
    static func lang(_ ru: String?, _ uz: String?, _ oz: String?) -> String {
        let lang = getAppLanguage()
        if lang == .oz {
            return oz ?? ""
        } else {
            return ru ?? ""
        }
    }
    
    static func setAppLanguage(_ lang: String?) {
        utilsDefaults?.set(lang, forKey: "lang")
        ecoGroupDefaults?.set(lang, forKey: "lang")
    }
    
    static func getAppLanguage() -> String {
        utilsDefaults?.string(forKey: "lang") ?? "ru"
    }
    
    static func getAppLocaleIdentifier() -> String {
        let appLanguage = getAppLanguage()
        switch Language(rawValue: appLanguage == "en" ? "oz" : appLanguage) {
        case .oz:
            return "uz_Latn_UZ"
        case .ru, .none:
            return Language.ru.localization_key
        }
    }
}
