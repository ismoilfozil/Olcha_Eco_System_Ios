import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

let baseSettings = SettingsDictionary().merging([
    "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
    "OTHER_LDFLAGS": "-ObjC",
    "SWIFT_VERSION": "5"
])
let settings = Settings(base: baseSettings)

let dependencies: [TargetDependency] = [
    .project(target: "OlchaAuth", path: "../OlchaAuth"),
    .project(target: "OlchaUI", path: "../OlchaUI"),
    .project(target: "OlchaPincode", path: "../OlchaPincode"),
    .project(target: "OlchaVerification", path: "../OlchaVerification"),
    .project(target: "OlchaBalance", path: "../OlchaBalance"),
    .project(target: "OlchaBilling", path: "../OlchaBilling"),
    .project(target: "OlchaCommon", path: "../OlchaCommon"),
]

let project = Project(
    name: "OlchaInvestCore",
    organizationName: "Olcha",
    targets: [
        Target(
            name: "OlchaInvestCore",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha-invest-core",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: .paths(["App/Sources/**"]),
            resources: ["App/Resources/**"],
            dependencies: dependencies,
            settings: settings
        )
    ]
)
