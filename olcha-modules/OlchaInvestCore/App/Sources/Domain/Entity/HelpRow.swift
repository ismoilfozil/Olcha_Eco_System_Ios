//
//  HelpRow.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 06/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public enum HelpRow: TableRowProtocol {
    case chat
    case phone
    case message
    case faq
    
    public var title: String {
        switch self {
        case .chat: return "help_chat".localized(.olchaInvestCore)
        case .phone: return "help_phone".localized(.olchaInvestCore)
        case .message: return "help_message".localized(.olchaInvestCore)
        case .faq: return "help_faq".localized(.olchaInvestCore)
        }
    }
    
    public var icon: UIImage? {
        switch self {
        case .chat: return .commentsAlt
        case .phone: return .phone
        case .message: return .envelopeAlt
        case .faq: return .fileQuestionAlt
        }
    }
}
