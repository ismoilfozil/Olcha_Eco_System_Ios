import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Extensions
extension SettingsDictionary {
    var addingObjcLinkerFlag: Self {
        return self.merging(["OTHER_LDFLAGS": "$(inherited) -ObjC"])
    }

    func addingDevelopmentAssets(path: String) -> Self {
        return self.merging(
            ["DEVELOPMENT_ASSET_PATHS": .init(arrayLiteral: path)]
        )
    }
}

let teamId = "8383CW6S7M"
let version = "1.0.0"
let buildNumber = "1"

let baseSettingsDictionary = SettingsDictionary()
    .bitcodeEnabled(false)
    .merging([
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
        "OTHER_LDFLAGS": "-ObjC",
        "DEVELOPMENT_TEAM": SettingValue(stringLiteral: teamId),
        "CFBundleShortVersionString": SettingValue(stringLiteral: version),
        "CFBundleVersion": SettingValue(stringLiteral: buildNumber),
        "SWIFT_VERSION": "5"
    ])

let settings = Settings.settings(base: baseSettingsDictionary)


let project = Project(
    name: "OlchaMarketModule",
    packages: [
        .remote(url: "https://github.com/tonyarnold/Differ",
                requirement: .upToNextMajor(from: "1.4.6")),
        .remote(url: "https://github.com/schmidyy/Loaf",
                requirement: .upToNextMajor(from: "0.6.0")),
        .remote(url: "https://github.com/psharanda/Atributika",
                requirement: .upToNextMajor(from: "4.10.1")),
        .remote(url: "https://github.com/lvnkmn/Zoomy",
                requirement: .upToNextMajor(from: "4.0.0")),
        .remote(url: "https://github.com/xasanovelbek/CountdownLabel",
                requirement: .branch("master")),
        .remote(url: "https://github.com/getsentry/sentry-cocoa.git",
                requirement: .upToNextMajor(from: "8.3.3")),
        .remote(url: "https://github.com/evgenyneu/Cosmos",
                requirement: .upToNextMajor(from: "23.0.0")),
//        .remote(url: "https://github.com/firebase/firebase-ios-sdk",
//                requirement: .upToNextMajor(from: "10.10.0")),
    ],
    settings: settings,
    targets: [
        Target(
            name: "OlchaMarketModule",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.OlchaMarketModule",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["OlchaMarketModule/Sources/**"],
            resources: ["OlchaMarketModule/Resources/**"],
            dependencies: [
                .project(target: "OlchaUI", path: "../OlchaUI"),
                .project(target: "OlchaCore", path: "../OlchaCore"),
                .project(target: "OlchaUtils", path: "../OlchaUtils"),
                .project(target: "OlchaVerification", path: "../OlchaVerification"),
                .project(target: "OlchaAuth", path: "../OlchaAuth"),
                .project(target: "OlchaBalance", path: "../OlchaBalance"),
                .project(target: "OlchaBankCards", path: "../OlchaBankCards"),
                .project(target: "OlchaPincode", path: "../OlchaPincode"),
                .project(target: "OlchaCommon", path: "../OlchaCommon"),
                .package(product: "Loaf"),
                .package(product: "Atributika"),
                .package(product: "Zoomy"),
                .package(product: "CountdownLabel"),
//                .package(product: "FirebaseAnalytics"),
//                .package(product: "FirebaseCrashlytics"),
//                .package(product: "FirebaseMessaging"),
                .package(product: "Cosmos")
            ],
            settings: settings,
            coreDataModels: [
                CoreDataModel("OlchaMarketModule/Sources/MyDB.xcdatamodeld")
            ]
        )
    ]
)

