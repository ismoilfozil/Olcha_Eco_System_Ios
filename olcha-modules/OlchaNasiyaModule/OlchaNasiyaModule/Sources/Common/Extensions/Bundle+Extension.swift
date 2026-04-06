//
//  Bundle+Extensions.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 27/05/23.
//

import Foundation
extension Bundle {
    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}
