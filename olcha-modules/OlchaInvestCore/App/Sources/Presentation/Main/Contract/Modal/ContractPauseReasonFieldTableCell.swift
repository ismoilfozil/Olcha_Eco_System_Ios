//
//  ContractPauseReasonFieldTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 03/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class ContractPauseReasonFieldTableCell: BaseTableCell {
    
    private let reasonField: InvestTField = {
        let field = InvestTField()
        field.topHint = "contract_reason_other_top_hint".localized(.olchaInvestCore)
        field.placeholder = "contract_reason_other_placeholder".localized(.olchaInvestCore)
        return field
    }()
    
    public override func setupViews() {
        container.addSubview(reasonField)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 14
        reasonField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public func reasonFieldObserver(completion: @escaping (_ text: String) -> Void) {
        reasonField.observeText { [weak self] in
            guard let self else { return }
            completion(reasonField.getValue())
        }
    }
    
}
