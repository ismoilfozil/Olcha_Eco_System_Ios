import Foundation
import ProjectDescription
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


let infoPlist = InfoPlist.file(path: "../Olcha/Info.plist")
let documentsPath = "/Users/ismoilfoziljonov/Downloads/ios2"

// MARK: - Constants

let companyName = "Olcha"
let teamId = "8383CW6S7M"
let projectName = "Olcha"
let version = "1.0.0"
let buildNumber = "1"


let baseSettingsDictionary = SettingsDictionary()
    .bitcodeEnabled(false)
    .addingObjcLinkerFlag
    .merging([
        "DEVELOPMENT_TEAM": SettingValue(stringLiteral: teamId),
        "CFBundleShortVersionString": SettingValue(stringLiteral: version),
        "CFBundleVersion": SettingValue(stringLiteral: buildNumber),
        "CFBundleLocalizations": SettingValue(arrayLiteral: "en", "ru", "uz-Cyrl"),
        "CFBundleDevelopmentRegion": SettingValue(stringLiteral: "en"),
        "SWIFT_VERSION": "5"
    ])

let settings = Settings(base: baseSettingsDictionary)
    
    
    let dependencies: [TargetDependency] = [
    .project(target: "OlchaMarketModule", path: "\(documentsPath)/olcha-modules/OlchaMarketModule"),
    .project(target: "ModuleGenerator", path: "\(documentsPath)/olcha-modules/ModuleGenerator"),
    .project(target: "OlchaUI", path: "\(documentsPath)/olcha-modules/OlchaUI"),
    .project(target: "OlchaUtils", path: "\(documentsPath)/olcha-modules/OlchaUtils"),
    .project(target: "OlchaPayModule", path: "\(documentsPath)/olcha-modules/OlchaPayModule"),
    .project(target: "OlchaNasiyaModule", path: "\(documentsPath)/olcha-modules/OlchaNasiyaModule"),
    .project(target: "OlchaInvestCore", path: "\(documentsPath)/olcha-modules/OlchaInvestCore"),
//    .package(product: "DropDown"),
    .package(product: "FirebaseAnalytics"),
    .package(product: "FirebaseCrashlytics"),
    .package(product: "FirebaseMessaging"),
    .package(product: "YandexMobileMetrica"),
    .target(name: "NotificationExtensionService"),
    .package(product: "MyIdSDK"),

]

let project = Project(
    name: "Olcha",
    organizationName: "Olcha",
    packages: [
        .remote(url: "https://github.com/yandexmobile/metrica-sdk-ios", requirement: .upToNextMajor(from: "4.5.2")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "10.10.0")),
        .remote(url: "https://gitlab.myid.uz/myid-public-code/myid-ios-sdk.git", requirement: .branch("master")),
    ],
    settings: settings,
    targets: [
        Target(
            name: "Olcha",
            platform: .iOS,
            product: .app,
            bundleId: "com.olcha.ecommerce",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .file(path: "Olcha/Info.plist"),
            sources: ["Olcha/Sources/**"],
            resources: ["Olcha/Resources/**"],
            dependencies: dependencies
        ),
        
        Target(
            name: "NotificationExtensionService",
            platform: .iOS,
            product: .appExtension,
            bundleId: "com.olcha.ecommerce.NotificationExtensionService",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(PRODUCT_NAME)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME)/Sources/.NotificationExtensionService"
                ]
            ]),
            sources: ["NotificationExtensionService/**"],
//            resources: ["NotificationExtensionService/**"],
            entitlements: "NotificationExtensionService/NotificationExtensionService.entitlements",
            dependencies: [
            ]
        )
    ],
    schemes: [
        Scheme(name: "Olcha",
               shared: true,
               buildAction: BuildAction(targets: ["Olcha"])
              )
    ]
    
)
