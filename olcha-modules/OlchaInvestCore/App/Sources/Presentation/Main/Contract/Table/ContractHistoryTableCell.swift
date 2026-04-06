//
//  ContractHistoryTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 29/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class ContractHistoryTableCell: BaseTableCell {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16.0)
        label.textColor = .olchaBlackNeutral
        label.text = "\t\t\t"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 12.0)
        label.textColor = .olchaBlackNeutral
        label.text = "\t\t\t"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16.0)
        label.textColor = .olchaSecondaryGreen
        label.text = "\t"
        return label
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = "\t\t\t"
        descriptionLabel.text = "\t\t\t"
        amountLabel.text = "\t"
    }
    
    public override func setupViews() {
        container.addSubview(iconImageView)
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(descriptionLabel)
        container.addSubview(amountLabel)
    }
    
    public override func autolayout() {
        verticalEdge = 4
        iconImageView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        contentStack.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.top.bottom.equalToSuperview().inset(8)
        }
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(contentStack.snp.right).offset(12)
            make.centerY.right.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        separatorInset = .zero
        configureSkeletion()
    }
    
    public func setup(with data: ContractHistoryModel, currency: String) {
        switch data.type {
        case .in:
            iconImageView.image = .transferProfit
        case .out:
            iconImageView.image = .transferLoss
        }
        descriptionLabel.text = data.type_message
        nameLabel.text = data.date
        if let amount = data.amount?.string {
            amountLabel.text = "\(amount.originalPriceWithoutCurrency) \(currency)"            
        }
    }
    
}

private extension ContractHistoryTableCell {
    func configureSkeletion() {
        makeSkeleton(views: [
            iconImageView,
            nameLabel,
            descriptionLabel,
            amountLabel,
        ])
        
        nameLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 70,
            height: .relativeToConstraints
        )
        descriptionLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 70,
            height: .relativeToConstraints
        )
        amountLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 70,
            height: .relativeToConstraints
        )
    }
}
