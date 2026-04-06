//
//  InvestHomeModalViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 19/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestHomeModalViewController: BaseModalViewController {
    
    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        return stack
    }()
    
    private let topLeftStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaInfoColor
        label.text = "ID:"
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 24)
        label.textColor = .olchaBlackNeutral
        label.text = 0.string.originalPrice
        return label
    }()
    
    private let investStatusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .arrowUpRight
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let boxStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let percentBox: RateBoxView = {
        let box = RateBoxView()
        box.setRateImage(image: .percentBoxIcon)
        return box
    }()
    
    private let termBox: RateBoxView = {
        let box = RateBoxView()
        box.setRateImage(image: .chartBoxIcon)
        return box
    }()
    
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.registerClass(forCell: InvestHomeModalTableCell.self)
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    public override func setupViews() {
        container.addSubview(topStack)
        topStack.addArrangedSubview(topLeftStack)
        topStack.addArrangedSubview(investStatusImage)
        topLeftStack.addArrangedSubview(idLabel)
        topLeftStack.addArrangedSubview(amountLabel)
        container.addSubview(boxStack)
        boxStack.addArrangedSubview(percentBox)
        boxStack.addArrangedSubview(termBox)
        container.addSubview(table)
    }
    
    public override func autolayout() {
        topStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        investStatusImage.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
        boxStack.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.top.equalTo(topStack.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        table.snp.makeConstraints { make in
            make.top.equalTo(boxStack.snp.bottom).offset(34)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        percentBox.setRateBoxGradient(.olchaLightOrangeGradient)
        termBox.setRateBoxGradient(.olchaLightBlueGradient)
        percentBox.setRateLabelText("contract_percent".localized(.olchaInvestCore))
        termBox.setRateLabelText("contract_term".localized(.olchaInvestCore))
        percentBox.setRateAmountLabelColor(.olchaOrange)
        termBox.setRateAmountLabelColor(.olchaInfoColor)
        setupModal(with: InvestModalData.mock())
    }
    
    public override func initialRequest() {
        table.reloadData()
        table.layoutIfNeeded()
    }
    
    public func setupModal(with data: InvestModalData) {
        idLabel.text = "ID: №\(data.id)"
        amountLabel.text = data.amount.string.originalPrice
        percentBox.setRateAmountLabelText(data.percent)
        termBox.setRateAmountLabelText(data.term)
    }
    
}
