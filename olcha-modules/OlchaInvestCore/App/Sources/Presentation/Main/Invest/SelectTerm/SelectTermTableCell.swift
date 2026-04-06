//
//  SelectTermTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class SelectTermTableCell: BaseTableCell {
    
    private lazy var termGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.locations = [0.0, 0.5]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0.3, y: 0.3)
        let color: UIColor = UIColor.olchaLightOrangeGradient ?? .olchaWhite
        gradient.colors = [color.cgColor, color.withAlphaComponent(0.2).cgColor]
        return gradient
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    private let termLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaShadeBlack
        return label
    }()
    
    private let termDescriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaDarkNeutralGray
        label.numberOfLines = 0
        return label
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 32)
        label.textColor = .olchaOrange
        return label
    }()
    
    public var isChosen: Bool = false {
        didSet {
            isChosen ? setGradient() : removeGradient()
            isChosen ? setSelectedBorder() : setDefaultBorder()
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        termLabel.text = "\t\t\t\t\t"
        termDescriptionLabel.text = "\t\t\t"
        percentLabel.text = "\t\t"
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        termGradient.frame = container.bounds
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(termLabel)
        contentStack.addArrangedSubview(termDescriptionLabel)
        container.addSubview(percentLabel)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 8
        contentStack.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(12)
            make.right.equalTo(percentLabel.snp.left).offset(-20)
        }
        percentLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview().inset(12)
        }
    }
    
    public override func configureViews() {
        container.border(with: .lightGrayBackground, width: 1.5)
        container.round()
        let termString = String(format: "term_value".localized(.olchaInvestCore), "0")
        termLabel.text = termString
        termDescriptionLabel.text = "Тут будет описание"
        percentLabel.text = "0%"
        configureSkeleton()
    }
    
    public func setup(with data: InvestmentModel) {
        let termString = String(format: "term_value".localized(.olchaInvestCore), data.term.orZero.string)
        termLabel.text = termString
        termDescriptionLabel.text = data.description.unwrap
        percentLabel.text = "\(data.percent.orZero)%"
    }
    
    private func setGradient() {
        container.removeCAGradientLayers()
        container.layer.insertSublayer(termGradient, at: 0)
    }
    
    private func removeGradient() {
        container.removeCAGradientLayers()
    }
    
    private func setSelectedBorder() {
        container.removeBorder()
        container.border(with: .olchaPrimaryColor, width: 1.5)
    }
    
    private func setDefaultBorder() {
        container.removeBorder()
        container.border(with: .lightGrayBackground, width: 1.5)
    }
    
}

private extension SelectTermTableCell {
    func configureSkeleton() {
        makeSkeleton(views: [
            termLabel,
            termDescriptionLabel,
            percentLabel
        ])
        
        termLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 60,
            height: .relativeToConstraints
        )
        termDescriptionLabel.skeletonConfiguration(
            lines: .custom(2),
            lastLinePercentage: 70,
            height: .relativeToConstraints
        )
        percentLabel.skeletonConfiguration(
            lines: .custom(1),
            lastLinePercentage: 50,
            height: .relativeToConstraints
        )
    }
}
