//
//  Bundle+Extensions.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

public extension Bundle {
    var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    var appBuild: String { getInfo("CFBundleVersion") }
    
    fileprivate func getInfo(_ str: String) -> String {
        infoDictionary?[str] as? String ?? "⚠️"
    }
}
