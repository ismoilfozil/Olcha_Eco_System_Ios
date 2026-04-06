//
//  PackagesTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 24/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class PackagesTableCell: BaseTableCell {
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaInfoColor
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaShadeBlack
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 4
        return label
    }()
    
    private let boxStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    public let percentBox: RateBoxView = {
        let box = RateBoxView()
        box.setRateBoxGradient(.olchaLightOrangeGradient)
        box.setRateAmountLabelColor(.olchaOrange)
        box.setRateImage(image: .percentBoxLeftIcon)
        box.style = .right
        return box
    }()
    
    public let termBox: RateBoxView = {
        let box = RateBoxView()
        box.setRateBoxGradient(.olchaLightBlueGradient)
        box.setRateAmountLabelColor(.olchaInfoColor)
        box.setRateImage(image: .chartBoxLeftIcon)
        box.style = .right
        return box
    }()
    
    public let currencyBox: RateBoxView = {
        let box = RateBoxView()
        box.setRateBoxGradient(.olchaLightGreenGradient)
        box.setRateAmountLabelColor(.olchaGreen)
        box.setRateImage(image: .currencyBoxLeftIcon)
        box.style = .right
        return box
    }()
    
    public let selectButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.round(10)
        button.isHidden = true
        return button
    }()
    
    private let detailsButton: IButton = {
        let button = IButton()
        button.border(with: .lightGrayBackground1)
        button.round(10)
        button.backgroundColor = .clear
        button.setTitleColor(.olchaBlackNeutral, for: .normal)
        button.titleLabel?.font = .style(.medium, 16)
        return button
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        percentBox.setRateLabelText("\t")
        percentBox.setRateAmountLabelText("\t")
        termBox.setRateLabelText("\t")
        termBox.setRateAmountLabelText("\t")
        currencyBox.setRateLabelText("\t")
        currencyBox.setRateAmountLabelText("\t")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(idLabel)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(descriptionLabel)
        contentStack.addArrangedSubview(boxStack)
        contentStack.addArrangedSubview(detailsButton)
        contentStack.addArrangedSubview(selectButton)
        boxStack.addArrangedSubview(percentBox)
        boxStack.addArrangedSubview(termBox)
        boxStack.addArrangedSubview(currencyBox)
    }
    
    public override func autolayout() {
        verticalEdge = 8
        horizontalEdge = 16
        
        contentStack.setCustomSpacing(20, after: descriptionLabel)
        contentStack.setCustomSpacing(20, after: boxStack)
        
        contentStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.left.right.equalToSuperview().inset(12)
        }
        boxStack.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
        detailsButton.snp.makeConstraints({ $0.height.equalTo(40) })
        selectButton.snp.makeConstraints({ $0.height.equalTo(40) })
    }
    
    public override func configureViews() {
        container.backgroundColor = .lightGrayBackground
        container.round()
        configureSkeleton()
    }
    
    public func setup(with data: InvestmentModel, isSelect: Bool = false) {
        percentBox.setRateLabelText("contract_percent".localized(.olchaInvestCore))
        termBox.setRateLabelText("contract_term".localized(.olchaInvestCore))
        currencyBox.setRateLabelText("package_currency".localized(.olchaInvestCore))
        detailsButton.setTitle("home_more".localized(.olchaInvestCore), for: .normal)
        selectButton.setTitle("select".localized(.olchaInvestCore))
        
        selectButton.isHidden = !isSelect
        
        idLabel.text = "№\(data.id.orZero)"
        titleLabel.text = data.name
        descriptionLabel.text = data.description
        percentBox.setRateAmountLabelText("\(data.percent.orZero)%")
        let termString = String(format: "term_value".localized(.olchaInvestCore), data.term_info.unwrap)
        termBox.setRateAmountLabelText(termString)
        currencyBox.setRateAmountLabelText(data.currency.unwrap.uppercased())
    }
    
    public func detailsButtonClicked(completion: (() -> Void)?) {
        detailsButton.clicked { completion?() }
    }
    
    public func selectButtonClicked(completion: (() -> Void)?) {
        selectButton.clicked { completion?() }
    }
    
}

private extension PackagesTableCell {
    func configureSkeleton() {
        makeSkeleton(views: [
            idLabel,
            titleLabel,
            descriptionLabel,
            detailsButton,
            selectButton,
            boxStack,
        ])
        
        idLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 50,
            height: .relativeToConstraints
        )
        titleLabel.skeletonConfiguration(
            lines: .custom(2),
            lastLinePercentage: 80,
            height: .relativeToConstraints
        )
        descriptionLabel.skeletonConfiguration(
            lines: .custom(4),
            lastLinePercentage: 60,
            height: .relativeToConstraints
        )
    }
}
