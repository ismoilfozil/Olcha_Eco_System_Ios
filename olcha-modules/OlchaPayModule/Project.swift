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
    name: "OlchaPayModule",
    packages: [
        .remote(url: "https://github.com/xasanovelbek/SimplePDF",
                requirement: .branch("master")),
//        .remote(url: "https://github.com/firebase/firebase-ios-sdk",
//                requirement: .upToNextMajor(from: "10.10.0")),
        .remote(url: "https://github.com/mercari/QRScanner", requirement: .upToNextMajor(from: "1.9.0")),
        .remote(url: "https://github.com/KelvinJin/AnimatedCollectionViewLayout", requirement: .upToNextMajor(from: "1.1.0")),
        .remote(url: "https://github.com/xasanovelbek/PinterestLayout", requirement: .branch("master")),
    ],
    targets: [
        Target(
            name: "OlchaPayModule",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.OlchaPayModule",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone]),
            infoPlist: .default,
            sources: ["OlchaPayModule/Sources/**"],
            resources: ["OlchaPayModule/Resources/**"],
            dependencies: [
                .project(target: "OlchaUI", path: "../OlchaUI"),
                .project(target: "OlchaCore", path: "../OlchaCore"),
                .project(target: "OlchaUtils", path: "../OlchaUtils"),
                .project(target: "OlchaPincode", path: "../OlchaPincode"),
                .project(target: "OlchaAuth", path: "../OlchaAuth"),
                .project(target: "OlchaCommon", path: "../OlchaCommon"),
                .project(target: "OlchaVerification", path: "../OlchaVerification"),

                .package(product: "SimplePDF"),
                .package(product: "QRScanner"),
                .package(product: "AnimatedCollectionViewLayout"),
                .package(product: "PinterestLayout"),
            ],
            settings: settings
            
        )
    ]
)
