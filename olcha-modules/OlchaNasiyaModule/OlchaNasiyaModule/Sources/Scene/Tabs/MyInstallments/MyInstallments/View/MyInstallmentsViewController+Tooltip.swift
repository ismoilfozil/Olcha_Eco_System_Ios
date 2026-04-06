//
//  MyInstallmentsViewController+Tooltip.swift
//  OlchaNasiyaModule
//
//  Created by Akhrorkhuja on 04/08/23.
//

import UIKit
import OlchaUI

public enum MyInstallmentsViewControllerTooltip: Tooltip {
    case selectButton(in: UIView)
    case singleInstallment(in: UIView)
    case filterButton(in: UIView)
    
    public static var allCases: [MyInstallmentsViewControllerTooltip] {
        let view = UIView()
        return [
            .selectButton(in: view),
            .singleInstallment(in: view),
            .filterButton(in: view)
        ]
    }
    
    public var prefix: String {
        return "my_installments_view_controller_"
    }
    
    public var key: String {
        switch self {
        case .selectButton:
            return "\(prefix)select_button_"
        case .singleInstallment:
            return "\(prefix)single_installment_"
        case .filterButton:
            return "\(prefix)filter_button_"
        }
    }
    
    public var view: UIView {
        switch self {
        case .selectButton(let view):
            return view
        case .singleInstallment(let view):
            return view
        case .filterButton(let view):
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
        switch self {
        case .selectButton, .singleInstallment:
            return .up
        case .filterButton:
            return .right
        }
    }
}

