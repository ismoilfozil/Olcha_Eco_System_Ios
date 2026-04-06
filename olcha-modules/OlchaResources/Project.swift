import ProjectDescription
import ProjectDescriptionHelpers

let settings = Settings(base: SettingsDictionary().merging([
    "SWIFT_VERSION": "5"
]))

let project = Project(
    name: "OlchaResources",
    targets: [
        Target(
            name: "OlchaResources",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.OlchaResources",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["OlchaResources/OlchaResources.h"],
            resources: ["OlchaResources/Resources/**"],
            settings: settings
        )
    ]
)
