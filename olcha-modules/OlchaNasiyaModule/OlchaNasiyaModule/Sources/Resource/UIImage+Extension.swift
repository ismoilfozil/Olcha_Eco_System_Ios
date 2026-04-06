//
//  UIImage+Extensions.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import OlchaUI
public extension UIImage {
    static let nasiya_home_tab: UIImage? = UIImage.tab_home
    static let nasiya_applications_tab: UIImage? = UIImage.bag
    static let nasiya_partners_tab: UIImage? = resolve(named: "nasiya_partners_tab", route: .olchaNasiyaModule)
    static let nasiya_profile_tab: UIImage? = resolve(named: "nasiya_profile_tab", route: .olchaNasiyaModule)
    static let location = resolve(named: "location", route: .olchaNasiyaModule)
    static let cards = resolve(named: "cards", route: .olchaNasiyaModule)
    static let lock = resolve(named: "lock", route: .olchaNasiyaModule)
    static let settings = resolve(named: "settings", route: .olchaNasiyaModule)
    static let passport_data = resolve(named: "passport_data", route: .olchaNasiyaModule)
    static let user = resolve(named: "user", route: .olchaNasiyaModule)
    static let circle_arrow_down = resolve(named: "circle_arrow_down", route: .olchaNasiyaModule)
    static let circle_arrow_up = resolve(named: "circle_arrow_up", route: .olchaNasiyaModule)
    static let graph_success = resolve(named: "graph_success", route: .olchaNasiyaModule)
    static let graph_progress = resolve(named: "graph_progress", route: .olchaNasiyaModule)
    
    static let telegram = resolve(named: "telegram", route: .olchaNasiyaModule)
    static let instagram = resolve(named: "instagram", route: .olchaNasiyaModule)
    static let facebook = resolve(named: "facebook", route: .olchaNasiyaModule)
    static let nasiya_logo = resolve(named: "nasiya-logo", route: .olchaNasiyaModule)
    
    static let uz_flag = resolve(named: "uz-flag", route: .olchaNasiyaModule)
    static let ru_flag = resolve(named: "rus-flag", route: .olchaNasiyaModule)
    
    static let right_arrow = resolve(named: "right_arrow", route: .olchaNasiyaModule)
    
    static let hamburger = resolve(named: "hamburger", route: .olchaNasiyaModule)
    
    
    static let faq = resolve(named: "faq", route: .olchaNasiyaModule)
    static let connection = resolve(named: "connection", route: .olchaNasiyaModule)
    
    static let verifyPlaceholder = resolve(named: "verify-placeholder", route: .olchaNasiyaModule)
    static let verificationRequested = resolve(named: "verification_requested", route: .olchaNasiyaModule)
    static let requestLimit = resolve(named: "request_limit", route: .olchaNasiyaModule)
    static let limitViewImage = resolve(named: "limit-view-image", route: .olchaNasiyaModule)
    
    static func onboarding_image(page: Int) -> UIImage? {
        resolve(named: "onboarding_\(page)", route: .olchaNasiyaModule)
    }
}
