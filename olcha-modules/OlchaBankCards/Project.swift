import ProjectDescription
import ProjectDescriptionHelpers

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

let settings = Settings.settings(base: baseSettingsDictionary)


let project = Project(
    name: "OlchaBankCards",
    packages: [
//        .remote(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", requirement: .upToNextMajor(from: "6.0.0")),
//        .remote(url: "https://github.com/Swinject/Swinject.git",
//                requirement: .upToNextMajor(from: "2.8.3")),
//        .remote(url: "https://github.com/Alamofire/Alamofire",
//                requirement: .upToNextMajor(from: "5.7.0")),
    ],
    targets: [
        Target(
            name: "OlchaBankCards",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.OlchaBankCards",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["OlchaBankCards/Sources/**"],
            dependencies: [
                .project(target: "OlchaCore", path: "../OlchaCore"),
                .project(target: "OlchaResources", path: "../OlchaResources"),
                .project(target: "OlchaUtils", path: "../OlchaUtils"),
                .project(target: "OlchaAuth", path: "../OlchaAuth"),
//                .package(product: "IQKeyboardManagerSwift"),
//                .package(product: "Alamofire"),
//                .package(product: "Swinject"),
            ],
            settings: settings
        )
    ]
)
