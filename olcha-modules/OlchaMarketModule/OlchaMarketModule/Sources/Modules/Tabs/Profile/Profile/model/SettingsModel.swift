//
//  SettingsModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/03/23.
//

import Foundation
struct SettingsData: Codable {
    var settings: [SettingsModel]?
}

struct SettingsModel: Codable {
    var type: String?
    var active: Bool?
}

