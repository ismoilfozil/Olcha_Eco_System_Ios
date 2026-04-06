//
//  UIImage+Extensions.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

extension UIImage {
    static let flagUz: UIImage? = resolve(named: "flag-uz", route: .olchaInvestCore)
    static let flagRu: UIImage? = resolve(named: "flag-ru", route: .olchaInvestCore)
    static let check: UIImage? = resolve(named: "u_check", route: .olchaInvestCore)
    
    static let post_1: UIImage? = resolve(named: "post_1", route: .olchaInvestCore)
    static let post_2: UIImage? = resolve(named: "post_2", route: .olchaInvestCore)
    
    static let bars: UIImage? = resolve(named: "u_bars", route: .olchaInvestCore)
    static let bell: UIImage? = resolve(named: "u_bell", route: .olchaInvestCore)
    
    static let commentsAlt: UIImage? = resolve(named: "u_comments-alt", route: .olchaInvestCore)
    static let exit: UIImage? = resolve(named: "u_exit", route: .olchaInvestCore)
    static let fileQuestionAlt: UIImage? = resolve(named: "u_file-question-alt", route: .olchaInvestCore)
    static let lightbulbAlt: UIImage? = resolve(named: "u_lightbulb-alt", route: .olchaInvestCore)
    
    static let arrowDown: UIImage? = resolve(named: "arrow-down", route: .olchaInvestCore)
    static let arrowUp: UIImage? = resolve(named: "arrow-up", route: .olchaInvestCore)
    
    static let investHomeTabItem: UIImage? = resolve(named: "home-tab-item", route: .olchaInvestCore)
    static let investRateTabItem: UIImage? = resolve(named: "rate-tab-item", route: .olchaInvestCore)
    static let investProfileTabItem: UIImage? = resolve(named: "profile-tab-item", route: .olchaInvestCore)
    
    static let arrowUpRight: UIImage? = resolve(named: "arrow-up-right", route: .olchaInvestCore)
    static let addButton: UIImage? = resolve(named: "add-button", route: .olchaInvestCore)
    
    static let percentBoxIcon: UIImage? = resolve(named: "percent-box-icon", route: .olchaInvestCore)
    static let chartBoxIcon: UIImage? = resolve(named: "chart-box-icon", route: .olchaInvestCore)
    
    static let percentBoxLeftIcon: UIImage? = resolve(named: "percent-box-left", route: .olchaInvestCore)
    static let chartBoxLeftIcon: UIImage? = resolve(named: "chart-box-left", route: .olchaInvestCore)
    static let currencyBoxLeftIcon: UIImage? = resolve(named: "currency-box-left", route: .olchaInvestCore)
    
    static let plustCircle: UIImage? = resolve(named: "u_plus-circle", route: .olchaInvestCore)
    static let cornerDownRightAlt: UIImage? = resolve(named: "u_corner-down-right-alt", route: .olchaInvestCore)
    static let history: UIImage? = resolve(named: "u_history", route: .olchaInvestCore)
    static let graphBar: UIImage? = resolve(named: "u_graph-bar", route: .olchaInvestCore)
    
    static let angleRight: UIImage? = resolve(named: "u_angle-right", route: .olchaInvestCore)
    static let angleRightB: UIImage? = resolve(named: "u_angle-right-b", route: .olchaInvestCore)
    
    static let arrowRight: UIImage? = resolve(named: "u_arrow-right", route: .olchaInvestCore)
    static let plus: UIImage? = resolve(named: "u_plus", route: .olchaInvestCore)
    static let uzcard: UIImage? = resolve(named: "Uzcard", route: .olchaInvestCore)
    
    static let arrowGrowth: UIImage? = resolve(named: "u_arrow-growth", route: .olchaInvestCore)
    
    static let transferLoss: UIImage? = resolve(named: "transfer-loss", route: .olchaInvestCore)
    static let transferProfit: UIImage? = resolve(named: "transfer-profit", route: .olchaInvestCore)
    
    static let creditCard: UIImage? = resolve(named: "u_credit-card", route: .olchaInvestCore)
    static let filesLandscapesAlt: UIImage? = resolve(named: "u_files-landscapes-alt", route: .olchaInvestCore)
    static let lock: UIImage? = resolve(named: "u_lock", route: .olchaInvestCore)
    static let userCircle: UIImage? = resolve(named: "u_user-circle", route: .olchaInvestCore)
    
    static let facebook: UIImage? = resolve(named: "facebook", route: .olchaInvestCore)
    static let instagram: UIImage? = resolve(named: "instagram", route: .olchaInvestCore)
    static let telegram: UIImage? = resolve(named: "telegram", route: .olchaInvestCore)
    
    static let olchaInvestHLogo: UIImage? = resolve(named: "olcha-invest-horizontal-logo", route: .olchaInvestCore)
    
    static let rbtnDefault: UIImage? = resolve(named: "rbtn-default", route: .olchaInvestCore)
    static let rbtn: UIImage? = resolve(named: "rbtn", route: .olchaInvestCore)
    
    static let shareAlt: UIImage? = resolve(named: "u_share-alt", route: .olchaInvestCore)
    static let star: UIImage? = resolve(named: "u_star", route: .olchaInvestCore)
    
    static let envelopeAlt: UIImage? = resolve(named: "u_envelope-alt", route: .olchaInvestCore)
    static let phone: UIImage? = resolve(named: "u_phone", route: .olchaInvestCore)
    
    static let multiply: UIImage? = resolve(named: "u_multiply", route: .olchaInvestCore)
    
    static func onboarding_image(page: Int) -> UIImage? {
        resolve(named: "onboarding_\(String.getAppLanguage())_\(page)", route: .olchaInvestCore)
    }
    
    static let mosquePic: UIImage? = resolve(named: "mosque-pic", route: .olchaInvestCore)
    
    static let historyConfirmed: UIImage? = resolve(named: "history-confirmed", route: .olchaInvestCore)
    static let historyCanceled: UIImage? = resolve(named: "history-canceled", route: .olchaInvestCore)
    static let historyInfo: UIImage? = resolve(named: "history-info", route: .olchaInvestCore)
}
