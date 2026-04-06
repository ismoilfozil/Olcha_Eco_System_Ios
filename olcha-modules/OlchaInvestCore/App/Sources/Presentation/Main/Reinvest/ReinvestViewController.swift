//
//  ReinvestViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 22/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class ReinvestViewController: BaseViewController<BackNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.horizontalEdge()
        scrollView.container.spacing = 16
        scrollView.settings.showsVerticalScrollIndicator = false
        scrollView.settings.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 72, right: 0)
        return scrollView
    }()
    
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: InvestCardTableCell.self)
        table.registerClass(forCell: InvestCardAddTableCell.self)
        table.isScrollEnabled = false
        table.contentInset.bottom = 72
        return table
    }()
    
    private let continueButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.setButtonEnabled(false)
        button.settings.setTitleColor(.olchaBlackNeutral, for: .disabled)
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.round(10)
        return button
    }()
    
    public var input: Input
    public var output: Output
    
    public init(
        input: Input = Input(),
        output: Output = Output()
    ) {
        self.input = input
        self.output = output
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(table)
        container.addSubview(continueButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        table.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        
    }
    
}
