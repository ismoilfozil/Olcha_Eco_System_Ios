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
    name: "OlchaBalance",
    packages: [
//            .remote(url: "https://github.com/hackiftekhar/IQKeyboardManager.git",
//                requirement: .upToNextMajor(from: "6.0.0")),
        
//            .remote(url: "https://github.com/Swinject/Swinject.git",
//                    requirement: .upToNextMajor(from: "2.8.3")),
        
//            .remote(url: "https://github.com/Alamofire/Alamofire",
//                    requirement: .upToNextMajor(from: "5.7.0")),
//
//            .remote(url: "https://github.com/SwiftyJSON/SwiftyJSON",
//                    requirement: .upToNextMajor(from: "5.0.0")),
            
            
        
    ],
    targets: [
        Target(
            name: "OlchaBalance",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.OlchaBalance",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["OlchaBalance/Sources/**"],
            resources: ["OlchaBalance/Resources/**"],
            dependencies: [
                .project(target: "OlchaUI", path: "../OlchaUI"),
                .project(target: "OlchaCore", path: "../OlchaCore"),
                .project(target: "OlchaUtils", path: "../OlchaUtils"),
                .project(target: "OlchaAuth", path: "../OlchaAuth"),
                .project(target: "OlchaBankCards", path: "../OlchaBankCards"),
//                .package(product: "IQKeyboardManagerSwift"),
//                .package(product: "Swinject"),
//                .package(product: "Alamofire"),
//                .package(product: "SwiftyJSON"),
            ],
            settings: settings
        )
    ]
)
