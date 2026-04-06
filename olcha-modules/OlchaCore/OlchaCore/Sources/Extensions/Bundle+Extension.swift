//
//  Bundle+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/12/22.
//

import Foundation
extension Bundle {
    public var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    public var buildVersionNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}
