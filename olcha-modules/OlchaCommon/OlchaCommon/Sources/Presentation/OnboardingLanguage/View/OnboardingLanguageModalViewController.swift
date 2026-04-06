//
//  OnboardingLanguageModalViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 14/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class OnboardingLanguageModalViewController: BaseModalViewController {
    
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.registerClass(forCell: OnboardingLanguageTableCell.self)
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.separatorColor = .olchaLightNeutralGray
        return table
    }()
    
    public override func setupViews() {
        container.addSubview(table)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
