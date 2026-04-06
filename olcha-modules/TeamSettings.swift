//
//  TeamSettings.swift
//  OlchaPincodeManifests
//
//  Created by Elbek Khasanov on 30/05/23.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

public let teamId = "8383CW6S7M"
public let version = "1.0.0"
public let buildNumber = "1"


public let baseSettingsDictionary = SettingsDictionary()
    .bitcodeEnabled(false)
    .addingObjcLinkerFlag
    .merging([
        "DEVELOPMENT_TEAM": SettingValue(stringLiteral: teamId),
        "CFBundleShortVersionString": SettingValue(stringLiteral: version),
        "CFBundleVersion": SettingValue(stringLiteral: buildNumber)
    ])

public let settings = Settings(base: baseSettingsDictionary)
