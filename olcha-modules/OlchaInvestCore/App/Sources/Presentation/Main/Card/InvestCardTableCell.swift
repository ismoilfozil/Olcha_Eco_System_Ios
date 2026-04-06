//
//  InvestCardTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class InvestCardTableCell: BaseTableCell {
    
    private lazy var cardGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.locations = [0.0, 0.5]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0.3, y: 0.3)
        let color: UIColor = UIColor.olchaLightGreenGradient ?? .olchaWhite
        gradient.colors = [color.cgColor, color.withAlphaComponent(0.2).cgColor]
        return gradient
    }()
    
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.round(8)
        return imageView
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaBlackNeutral
        return label
    }()
    
    private let detailsStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let cardHolderNameLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 12)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let cardIssueDateLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 12)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    public var isChosen: Bool = false {
        didSet {
            isChosen ? setGradient() : removeGradient()
            isChosen ? setSelectedBorder() : container.removeBorder()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        container.layoutIfNeeded()
        cardGradient.frame = container.bounds
    }
    
    public override func setupViews() {
        container.addSubview(cardImageView)
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(cardNumberLabel)
        contentStack.addArrangedSubview(detailsStack)
        detailsStack.addArrangedSubview(cardHolderNameLabel)
        detailsStack.addArrangedSubview(cardIssueDateLabel)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 8
        
        cardImageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(12)
            make.width.equalTo(48)
        }
        contentStack.snp.makeConstraints { make in
            make.left.equalTo(cardImageView.snp.right).offset(8)
            make.top.right.bottom.equalToSuperview().inset(12)
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .lightGrayBackground
        container.round(8)
        cardImageView.image = .uzcard
    }
    
    public func setup(with data: CardModel) {
        cardNumberLabel.text = data.number.unwrap.makeReadableCardNumber
        cardHolderNameLabel.text = data.name.unwrap
        cardIssueDateLabel.text = data.expireDate.unwrap.makeReadableExpireDateForCard
    }
    
    private func setGradient() {
        container.removeCAGradientLayers()
        container.layer.insertSublayer(cardGradient, at: 0)
    }
    
    private func removeGradient() {
        container.removeCAGradientLayers()
    }
    
    private func setSelectedBorder() {
        container.removeBorder()
        container.border(with: .olchaGreen, width: 1.5)
    }
    
}
