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
let projectPath = "../"

let project = Project(
    name: "OlchaNasiyaModule",
    packages: [
//        .remote(url: "https://github.com/hackiftekhar/IQKeyboardManager.git",
//               requirement: .upToNextMajor(from: "6.0.0")),
        
//        .remote(url: "https://github.com/gmarm/BetterSegmentedControl",
//                requirement: .upToNextMajor(from: "2.0.0")),
//        .remote(url: "https://github.com/yandexmobile/metrica-sdk-ios",
//                    requirement: .upToNextMajor(from: "4.5.2")),
//        .remote(url: "https://github.com/firebase/firebase-ios-sdk",
//                requirement: .upToNextMajor(from: "10.10.0")),
        
//        .remote(url: "https://github.com/Swinject/Swinject.git",
//                requirement: .upToNextMajor(from: "2.8.3")),
        
//        .remote(url: "https://github.com/Alamofire/Alamofire",
//                requirement: .upToNextMajor(from: "5.7.0")),
                    
    ],
    targets: [
        Target(
            name: "OlchaNasiyaModule",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.OlchaNasiyaModule",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["OlchaNasiyaModule/Sources/**"],
            resources: ["OlchaNasiyaModule/Resources/**"],
            dependencies: [
                .project(target: "OlchaUI", path: "\(projectPath)OlchaUI"),
                .project(target: "OlchaCore", path: "\(projectPath)OlchaCore"),
                .project(target: "OlchaUtils", path: "\(projectPath)OlchaUtils"),
                .project(target: "OlchaVerification", path: "\(projectPath)OlchaVerification"),
                .project(target: "OlchaAuth", path: "\(projectPath)OlchaAuth"),
                .project(target: "OlchaBalance", path: "\(projectPath)OlchaBalance"),
                .project(target: "OlchaBankCards", path: "\(projectPath)OlchaBankCards"),
                .project(target: "OlchaPincode", path: "\(projectPath)OlchaPincode"),
                .project(target: "OlchaBilling", path: "\(projectPath)OlchaBilling"),
                .project(target: "OlchaCommon", path: "\(projectPath)OlchaCommon"),
//                .package(product: "YandexMobileMetrica"),
                //                .package(product: "Swinject"),
//                .package(product: "BetterSegmentedControl"),
//                .package(product: "IQKeyboardManagerSwift"),
                //                .package(product: "Alamofire")
                
//                .package(product: "FirebaseAnalytics"),
//                .package(product: "FirebaseCrashlytics"),
//                .package(product: "FirebaseMessaging"),
            ],
            settings: settings
        )
    ]
)
