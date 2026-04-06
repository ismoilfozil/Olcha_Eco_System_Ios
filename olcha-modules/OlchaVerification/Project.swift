import ProjectDescription
import ProjectDescriptionHelpers
import Foundation


let teamId = "8383CW6S7M"
let version = "1.0.0"
let buildNumber = "1"

let baseSettingsDictionary = SettingsDictionary()
    .bitcodeEnabled(false)
    .merging([
        "DEVELOPMENT_TEAM": SettingValue(stringLiteral: teamId),
        "CFBundleShortVersionString": SettingValue(stringLiteral: version),
        "CFBundleVersion": SettingValue(stringLiteral: buildNumber),
        "SWIFT_VERSION": "5"
    ])

let settings = Settings(base: baseSettingsDictionary)

let project = Project(
    name: "OlchaVerification",
    packages: [
        .remote(url: "https://gitlab.myid.uz/myid-public-code/myid-ios-sdk.git", requirement: .branch("master")),
    ],
    targets: [
        Target(
            name: "OlchaVerification",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.OlchaVerification",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["OlchaVerification/Sources/**"],
            resources: ["OlchaVerification/Resources/**"],
            dependencies: [
                .project(target: "OlchaUI", path: "../OlchaUI"),
                .project(target: "OlchaCore", path: "../OlchaCore"),
                .project(target: "OlchaUtils", path: "../OlchaUtils"),
                .project(target: "OlchaBankCards", path: "../OlchaBankCards"),
                .project(target: "OlchaAuth", path: "../OlchaAuth"),
                .package(product: "MyIdSDK"),
            ],
            settings: settings
        )
    ]
)
