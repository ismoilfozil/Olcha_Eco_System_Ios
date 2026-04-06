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
    name: "OlchaUI",
    packages: [
        .remote(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", requirement: .upToNextMajor(from: "6.0.0")),
        .remote(url: "https://github.com/xasanovelbek/ProgressHUD",
                requirement: .branch("master")),
        .remote(url: "https://github.com/gmarm/BetterSegmentedControl",
                requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.0")),
        .remote(url: "https://github.com/airbnb/lottie-ios.git", requirement: .upToNextMajor(from: "4.0.0")),
        .remote(url: "https://github.com/AssistoLab/DropDown.git", requirement: .branch("master")),
        .remote(url: "https://github.com/xasanovelbek/AORangeSlider",
                requirement: .branch("master")),
        .remote(url: "https://github.com/marcosgriselli/ViewAnimator.git", requirement: .upToNextMajor(from: "3.0.0")),
        .remote(url: "https://github.com/tonyarnold/Differ.git", requirement: .upToNextMajor(from: "1.4.0")),
        .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "6.0.0")),
        .remote(url: "https://github.com/SVGKit/SVGKit", requirement: .upToNextMajor(from: "3.0.0")),
        .remote(url: "https://github.com/Juanpe/SkeletonView.git", requirement: .upToNextMinor(from: "1.30.0")),
        .remote(url: "https://github.com/rishi420/Bonsai.git", requirement: .upToNextMajor(from: "7.0.0")),
        .remote(url: "https://github.com/ivanvorobei/SPStorkController", requirement: .upToNextMajor(from: "1.8.5")),
        .remote(url: "https://github.com/BenEmdon/CenteredCollectionView",
                requirement: .upToNextMajor(from: "2.2.2")),
        .remote(url: "https://github.com/jonkykong/SideMenu",
                requirement: .upToNextMajor(from: "6.5.0")),
        .remote(url: "https://github.com/devxoul/Toaster", requirement: .branch("master")),
        .remote(url: "https://github.com/wxxsw/GSMessages", requirement: .branch("master")),
        .remote(url: "https://github.com/slackhq/PanModal", requirement: .upToNextMajor(from: "1.2.7")),
    ],
    targets: [
        Target(
            name: "OlchaUI",
            platform: .iOS,
            product: .framework,
            bundleId: "com.olcha.OlchaUI",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
            infoPlist: .default,
            sources: ["OlchaUI/Sources/**"],
            resources: [
                "OlchaUI/Resources/**",
                "OlchaUI/Bundles/*.mlmodelc",
                "OlchaUI/Bundles/*.html",
            ],
            dependencies: [
                .project(target: "OlchaCore", path: "../OlchaCore"),
                .project(target: "OlchaResources", path: "../OlchaResources"),
                .project(target: "OlchaUtils", path: "../OlchaUtils"),
                .package(product: "ProgressHUD"),
                .package(product: "SnapKit"),
                .package(product: "IQKeyboardManagerSwift"),
                .package(product: "Lottie"),
                .package(product: "DropDown"),
                .package(product: "ViewAnimator"),
                .package(product: "Differ"),
                .package(product: "Kingfisher"),
                .package(product: "SVGKit"),
                .package(product: "SkeletonView"),
                .package(product: "BonsaiController"),
                .package(product: "SPStorkController"),
                .package(product: "CenteredCollectionView"),
                .package(product: "AORangeSlider"),
                .package(product: "SideMenu"),
                .package(product: "BetterSegmentedControl"),
                .package(product: "Toaster"),
                .package(product: "GSMessages"),
                .package(product: "PanModal"),
            ],
            
            settings: settings
        )
    ]
)
