//
//  OnboardingLanguageTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 15/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class OnboardingLanguageTableCell: BaseTableCell {
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        return stack
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let checkedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .check_light
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    public var isChosen: Bool = false {
        didSet {
            checkedImageView.isHidden = !isChosen
        }
    }
    
    public override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(iconImageView)
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(checkedImageView)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(28)
        }
        checkedImageView.snp.makeConstraints { make in
            make.width.equalTo(20)
        }
    }
    
    public func setup(with data: RowProtocol) {
        iconImageView.image = data.image
        titleLabel.text = data.title
    }
    
}
