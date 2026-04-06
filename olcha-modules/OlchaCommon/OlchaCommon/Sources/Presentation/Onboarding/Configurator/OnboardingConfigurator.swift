//
//  OnboardingConfigurator.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 10/10/23.
//

import Foundation
import UIKit
import OlchaUI
import OlchaUtils
public class OnboardingConfigurator {
    ///
    /// ``languages`` is languages of applications
    ///
    nonisolated(unsafe) public static var languages: [OnboardingLanguageRow] = [ .oz, .ru ]

    ///
    /// ``bundleType`` is to get `UIImage`
    ///
    nonisolated(unsafe) public static var bundleType: BundleType = .olcha

    ///
    /// ``application`` is to know which  `Application` is running
    ///
    nonisolated(unsafe) public static var application: OlchaModule = .olcha

    ///
    /// ``pages`` is count of onboarding `pages`
    ///
    nonisolated(unsafe) public static var pages: Int = 4

    ///
    /// ``image_localized`` localized part of image name in `Assets`. For example
    /// `image_name = onboarding_image_uz_0`
    ///
    nonisolated(unsafe) public static var is_image_localized: Bool = false

    ///
    /// ``image_id`` main part of image name in `Assets`. For example
    /// `image_name = onboarding_image_0`
    ///
    nonisolated(unsafe) public static var image_id = "onboarding_image"

    ///
    /// ``title_id`` main part of title name in `Localizable`. For example
    /// `title_name = onboarding_title_0`
    ///
    nonisolated(unsafe) public static var title_id = "onboarding_title"

    ///
    /// ``subtitle_id`` main part of title name in `Localizable`. For example
    /// `subtitle_name = onboarding_subtitle_0`
    ///
    nonisolated(unsafe) public static var subtitle_id = "onboarding_subtitle"

    ///
    /// ``isSubtitleHidden`` is `subtitle` hide/show property
    ///
    nonisolated(unsafe) public static var isSubtitleHidden: Bool = false

    ///
    /// ``isLeftButtonHidden`` is `leftButton` hide/show property
    ///
    nonisolated(unsafe) public static var isLeftButtonHidden: Bool = false

    ///
    /// ``isRightButtonHidden`` is `rightButton` hide/show property
    ///
    nonisolated(unsafe) public static var isRightButtonHidden: Bool = false

    ///
    /// ``isLogoHidden`` is `logoImageView` hide/show property
    ///
    nonisolated(unsafe) public static var isLogoHidden: Bool = true

    ///
    /// ``logoImageId`` is main part of title name in `Localizable`. For example
    /// `logo_image = onboarding_logo_0`
    ///
    nonisolated(unsafe) public static var logoImageId = "onboarding_logo"

    ///
    /// ``group_bundle_name`` is group name for `NotificationExtension` in order to change its titles
    ///
    nonisolated(unsafe) public static var group_bundle_name = ""
    
    public static func configure(languages: [OnboardingLanguageRow] = [ .oz, .ru ],
                                 bundleType: BundleType = .olcha,
                                 application: OlchaModule = .olcha,
                                 pages: Int = 4,
                                 is_image_localized: Bool = false,
                                 image_id: String = "onboarding_image",
                                 title_id: String = "onboarding_title",
                                 subtitle_id: String = "onboarding_subtitle",
                                 isSubtitleHidden: Bool = false,
                                 isLeftButtonHidden: Bool = false,
                                 isRightButtonHidden: Bool = false,
                                 isLogoHidden: Bool = true,
                                 logoImageId: String = "onboarding_logo",
                                 group_bundle_name: String = "") {
        self.languages = languages
        self.bundleType = bundleType
        self.application = application
        self.pages = pages
        self.is_image_localized = is_image_localized
        self.image_id = image_id
        self.title_id = title_id
        self.subtitle_id = subtitle_id
        self.isSubtitleHidden = isSubtitleHidden
        self.isLeftButtonHidden = isLeftButtonHidden
        self.isRightButtonHidden = isRightButtonHidden
        self.isLogoHidden = isLogoHidden
        self.logoImageId = logoImageId
        self.group_bundle_name = group_bundle_name
    }
    
    
    //MARK: - Actual name generator
    ///
    /// ``imageName(index: Int)`` this func creates actual name of image in `Assets`. For example:
    /// `imageName(index: indexPath.item)`
    ///
    internal static func image(index: Int) -> UIImage? {
        let languageSuffix = is_image_localized ? String.getAppLanguage() : ""
        let indexSuffix = index.string
        
        let imageName: String = image_id.concat(prefix: "_", extras: [ languageSuffix, indexSuffix ])
        
        
        return UIImage.resolve(named: imageName, route: bundleType)
    }
    
    ///
    /// ``logoImage(index: Int)`` this func creates actual name of logo image in `Assets`. For example:
    /// `logoImage(index: indexPath.item)`
    ///
    internal static func logoImage(index: Int) -> UIImage? {
        let languageSuffix = is_image_localized ? String.getAppLanguage() : ""
        let indexSuffix = index.string
        
        let imageName: String = logoImageId.concat(prefix: "_", extras: [languageSuffix, indexSuffix])
        
        return UIImage.resolve(named: imageName, route: bundleType)
    }
    
    ///
    /// ``titleName(index: Int)`` this func creates actual name of title in `Localizable`. For example:
    /// `titleName(index: indexPath.item)`
    ///
    internal static func title(index: Int) -> String {
        (title_id + "_\(index)").localized(bundleType)
    }
    
    ///
    /// ``subtitleName(index: Int)`` this func creates actual name of subtitle in `Localizable`. For example:
    /// `subtitleName(index: indexPath.item)`
    ///
    internal static func subtitle(index: Int) -> String {
        (subtitle_id + "_\(index)").localized(bundleType)
    }
}
