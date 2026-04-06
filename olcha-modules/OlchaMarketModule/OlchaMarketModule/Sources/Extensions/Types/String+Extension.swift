////
////  String+Extension.swift
////  NewOlcha
////
////  Created by Elbek Khasanov on 30/06/22.
////
//
//import UIKit
//import SwiftSoup
import Foundation
import OlchaUI
import OlchaCore
public extension String {
//    public static var olchaLanguage: String? = ""
//    
//    public func localized() -> String {
//        print("olcha language", String.olchaLanguage)
//        return self.baseLocalized(lang: .olchaLanguage)
//    }
//
//    public static func lang(_ ru: String?, _ uz: String?, _ oz: String?) -> String {
//        return .baseLang(ru, uz, oz, lang: .olchaLanguage)
//    }
    var month: String {
        return self + " " + "month_short".localized()
    }
}
