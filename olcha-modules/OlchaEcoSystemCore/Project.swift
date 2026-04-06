import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

let baseSettings: SettingsDictionary = [
    "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
    "OTHER_LDFLAGS": "-ObjC",
    "SWIFT_VERSION": "5"
]
let settings: Settings = Settings(base: baseSettings)

let dependencies: [TargetDependency] = [
    .project(target: "OlchaAuth", path: "../OlchaAuth"),
    .project(target: "OlchaUI", path: "../OlchaUI"),
    .project(target: "OlchaBalance", path: "../OlchaBalance"),
    .project(target: "OlchaNasiyaModule", path: "../OlchaNasiyaModule"),
    .project(target: "OlchaInvestCore", path: "../OlchaInvestCore"),
    .project(target: "OlchaMarketModule", path: "../OlchaMarketModule"),
    .project(target: "OlchaPayModule", path: "../OlchaPayModule"),
    .project(target: "OlchaCommon", path: "../OlchaCommon"),
    .project(target: "OlchaCashback", path: "../OlchaCashback"),
    .project(target: "OlchaSayohat", path: "../OlchaSayohat"),
]

let project = Project(
    name: "OlchaEcoSystemCore",
    organizationName: "Olcha",
    targets: [
        Target(
            name: "OlchaEcoSystemCore",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.eco-system-core",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: dependencies,
            settings: settings
        )
    ]
)
