//
//  AboutRow.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public enum AboutRow: TableRowProtocol {
    case rate
    case share
    
    public var title: String {
        switch self {
        case .rate: return "about_rate_us".localized(.olchaInvestCore)
        case .share: return "about_share".localized(.olchaInvestCore)
        }
    }
    
    public var icon: UIImage? {
        switch self {
        case .rate: return .star
        case .share: return .shareAlt
        }
    }
}
