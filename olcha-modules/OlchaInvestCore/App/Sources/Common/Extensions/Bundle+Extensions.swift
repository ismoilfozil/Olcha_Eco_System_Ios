//
//  Bundle+Extensions.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation

extension Bundle {
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    public var appBuild: String { getInfo("CFBundleVersion") }
    
    fileprivate func getInfo(_ str: String) -> String {
        infoDictionary?[str] as? String ?? "⚠️"
    }
}
