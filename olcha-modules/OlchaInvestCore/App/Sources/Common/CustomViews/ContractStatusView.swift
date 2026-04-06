//
//  ContractStatusView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 24/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class ContractStatusView: BaseView {
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12.0)
        return label
    }()
    
    public enum ContractStatus: String {
        case active
        case paused
        case cancelled
        case pending_for_payment
        case none
        
        public var title: String {
            switch self {
            case .active: return "contract_status_active".localized(.olchaInvestCore)
            case .paused: return "contract_status_paused".localized(.olchaInvestCore)
            case .cancelled: return "contract_status_cancelled".localized(.olchaInvestCore)
            case .pending_for_payment: return "contract_status_pending_for_payment".localized(.olchaInvestCore)
            case .none: return ""
            }
        }
        
        public var color: UIColor {
            switch self {
            case .active:
                return .olchaGreen ?? .green
            case .paused, .pending_for_payment:
                return .olchaOrange ?? .orange
            case .cancelled:
                return .olchaPrimaryColor
            case .none:
                return .clear
            }
        }
    }
    
    public var status: ContractStatus = .none {
        didSet {
            statusLabel.text = status.title
            statusLabel.textColor = status.color
            backgroundColor = status.color.withAlphaComponent(0.1)
        }
    }
    
    public override func setupViews() {
        addSubview(statusLabel)
    }
    
    public override func autolayout() {
        statusLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(6)
        }
    }
    
    public override func configureViews() {
        round(6)
    }
    
    public override func languageUpdated() {
        statusLabel.text = status.title
    }
    
}
