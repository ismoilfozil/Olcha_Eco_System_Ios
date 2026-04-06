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

let settings = Settings(base: baseSettingsDictionary)

let project = Project(
    name: "OlchaUtils",
    packages: [
        .remote(url: "https://github.com/Swinject/Swinject.git", requirement: .upToNextMajor(from: "2.8.3")),
        .remote(url: "https://github.com/scinfu/SwiftSoup.git", requirement: .upToNextMajor(from: "2.6.0")),

    ],
    targets: [
        Target(
            name: "OlchaUtils",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.OlchaUtils",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["OlchaUtils/**"],
            dependencies: [
                .project(target: "OlchaCore", path: "../OlchaCore"),
                .package(product: "Swinject"),
                .package(product: "SwiftSoup"),
//                .package(product: "YandexMobileMetrica")
            ],
            settings: settings
        )
    ]
)
