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
    name: "OlchaCashback",
    packages: [],
    targets: [
        Target(
            name: "OlchaCashback",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.OlchaCashback",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["OlchaCashback/Sources/**"],
//            resources: ["OlchaCashback/Resources/**"],
            dependencies: [
                .project(target: "OlchaUI", path: "../OlchaUI"),
                .project(target: "OlchaAuth", path: "../OlchaAuth"),
                .project(target: "OlchaUtils", path: "../OlchaUtils"),
            ],
            settings: settings
        )
    ]
)
