import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Constants

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
    name: "ModuleGenerator",
    packages: [
        
    ],
    targets: [
        Target(
            name: "ModuleGenerator",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.ModuleGenerator",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["ModuleGenerator/**"],
            dependencies: [
                .project(target: "OlchaInvestCore", path: "../OlchaInvestCore"),
                .project(target: "OlchaPayModule", path: "../OlchaPayModule"),
                .project(target: "OlchaMarketModule", path: "../OlchaMarketModule"),
                .project(target: "OlchaEcoSystemCore", path: "../OlchaEcoSystemCore"),
                .project(target: "OlchaCore", path: "../OlchaCore"),
                .project(target: "OlchaUtils", path: "../OlchaUtils"),
                .project(target: "OlchaUI", path: "../OlchaUI"),
            ],
            settings: settings
        )
    ]
)
