//
//  ModulesConfiguration.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/04/23.
//

import OlchaUI
import UIKit
import OlchaPayModule
import OlchaUtils
import OlchaAuth
import OlchaMarketModule
class ModulesConfiguration {
    nonisolated(unsafe) static let shared = ModulesConfiguration()
    
    func setup() {
        UIFont.registerAllFonts()
    }
}
