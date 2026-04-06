//
//  MyInstallmentViewController+Tooltip.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 04/08/23.
//

import UIKit
import OlchaUI

public enum MyInstallmentViewControllerTooltip: Tooltip {
    case installmentNumber(in: UIView)
    case paidContent(in: UIView)
    case needContent(in: UIView)
    case graphicSegment(in: UIView)
    case detailSegment(in: UIView)
    
    public static var allCases: [MyInstallmentViewControllerTooltip] {
        let view = UIView()
        return [
            .installmentNumber(in: view),
            .paidContent(in: view),
            .needContent(in: view),
            .graphicSegment(in: view),
            .detailSegment(in: view),
        ]
    }
    
    public var prefix: String {
        return "my_installment_view_controller_"
    }
    
    public var key: String {
        switch self {
        case .installmentNumber:
            return "\(prefix)installment_number_"
        case .paidContent:
            return "\(prefix)paid_content_"
        case .needContent:
            return "\(prefix)need_content_"
        case .graphicSegment:
            return "\(prefix)graphic_segment_"
        case .detailSegment:
            return "\(prefix)detail_segment_"
        }
    }
    
    public var view: UIView {
        switch self {
        case .installmentNumber(let view):
            return view
        case .paidContent(let view):
            return view
        case .needContent(let view):
            return view
        case .graphicSegment(let view):
            return view
        case .detailSegment(let view):
            return view
        }
    }
    
    public var didShow: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public var title: String? {
        return "\(key)title".localized(.olchaNasiyaModule)
    }
    
    public var message: String {
        return "\(key)description".localized(.olchaNasiyaModule)
    }
    
    public var direction: TooltipDirection {
        return .up
    }
}

