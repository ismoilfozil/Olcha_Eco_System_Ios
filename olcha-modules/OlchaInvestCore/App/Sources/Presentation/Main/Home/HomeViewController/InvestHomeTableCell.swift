//
//  InvestHomeTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestHomeTableCell: BaseTableCell {
    
    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaBlackNeutral
        label.text = "\t"
        return label
    }()
    
    private let contractStatusView = ContractStatusView()
    
    private let contractName: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18.0)
        label.textColor = .olchaBlackNeutral
        label.text = "\t"
        return label
    }()
    
    private let amountStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 24)
        label.textColor = .olchaBlackNeutral
        label.text = "\t"
        return label
    }()
    
    private let investStatusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .arrowUpRight
        return imageView
    }()
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let withdrawalButton: IButton = {
        let button = IButton()
        button.setTitleColor(.olchaBlackNeutral, for: .normal)
        button.titleLabel?.font = .style(.medium, 14.0)
        button.backgroundColor = .olchaLightNeutralGray
        button.round(8.0)
        return button
    }()
    
    private let detailsButton: IButton = {
        let button = IButton()
        button.setTitleColor(.lightGrayBackground, for: .normal)
        button.titleLabel?.font = .style(.medium, 14.0)
        button.backgroundColor = .olchaPrimaryColor
        button.round(8.0)
        return button
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        idLabel.text = "\t"
        contractName.text = "\t"
        amountLabel.text = "\t"
        contractStatusView.status = .none
    }
    
    public override func setupViews() {
        container.addSubview(topStack)
        topStack.addArrangedSubview(idLabel)
        topStack.addArrangedSubview(contractStatusView)
        container.addSubview(contractName)
        container.addSubview(amountStack)
        container.addSubview(buttonStack)
        amountStack.addArrangedSubview(amountLabel)
        amountStack.addArrangedSubview(investStatusImage)
        buttonStack.addArrangedSubview(withdrawalButton)
        buttonStack.addArrangedSubview(detailsButton)
    }
    
    public override func autolayout() {
        verticalEdge = 8
        horizontalEdge = 16
        topStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        contractName.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        amountStack.snp.makeConstraints { make in
            make.top.equalTo(contractName.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(24)
        }
        investStatusImage.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        buttonStack.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.top.equalTo(amountStack.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        container.round(14.0)
        container.backgroundColor = .lightGrayBackground
        configureSkeleton()
    }
    
    public func setup(with data: InvestorContractModel) {
        withdrawalButton.setTitle("profit_withdraw".localized(.olchaInvestCore), for: .normal)
        detailsButton.setTitle("home_more".localized(.olchaInvestCore), for: .normal)
        idLabel.text = "ID: №\(data.id.orZero)"
        contractName.text = data.contract_name.unwrap
        amountLabel.text = "\(data.start_invest.orZero) \(data.unwrappedCurrency)"
        switch data.status_type {
        case .active:
            contractStatusView.status = .active
        case .inactive:
            contractStatusView.status = .cancelled
        case .paused:
            contractStatusView.status = .paused
        case .pending_for_payment:
            contractStatusView.status = .pending_for_payment
        }
    }
    
    public func detailsButtonClicked(completion: (() -> Void)?) {
        detailsButton.clicked { completion?() }
    }
    
    public func withdrawalButtonClicked(completion: (() -> Void)?) {
        withdrawalButton.clicked { completion?() }
    }
    
}

private extension InvestHomeTableCell {
    func configureSkeleton() {
        makeSkeleton(views: [
            idLabel,
            contractStatusView,
            contractName,
            amountLabel,
            investStatusImage,
            withdrawalButton,
            detailsButton,
        ])
        
        idLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 50,
            height: .relativeToConstraints
        )
        contractName.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 70,
            height: .relativeToConstraints
        )
        amountLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 50,
            height: .relativeToConstraints
        )
    }
}
