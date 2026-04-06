//
//  FaqTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import OlchaCommon

public class FaqTableCell: BaseTableCell {
    
    private let containerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        return stackView
    }()
    
    private let expandeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .arrowDown
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.text = "\t"
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.isHidden = true
        label.text = "\t"
        return label
    }()
    
    public var model: CommonFAQModel?
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }

    public override func setupViews() {
        container.addSubview(containerStack)
        container.addSubview(expandeImageView)
        
        containerStack.addArrangedSubview(headerLabel)
        containerStack.addArrangedSubview(contentLabel)
    }
    
    public override func configureViews() {
        configureSkeleton()
    }
    
    public override func autolayout() {
        expandeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(expandeImageView.snp.right).inset(-12)
            make.bottom.greaterThanOrEqualTo(expandeImageView.snp.bottom)
            make.bottom.equalToSuperview().inset(16)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
    }
    
    public func setup(with data: CommonFAQModel) {
        self.model = data
        headerLabel.text = data.getTitle()
        contentLabel.text = data.getContent()
        animate()
    }

}

private extension FaqTableCell {
    func configureSkeleton() {
        makeSkeleton(views: [
            expandeImageView,
            headerLabel,
            contentLabel
        ])
        
        headerLabel.skeletonConfiguration(
            lines: .custom(2),
            lastLinePercentage: 70,
            height: .relativeToConstraints
        )
        contentLabel.skeletonConfiguration(
            lines: .custom(2),
            lastLinePercentage: 80,
            height: .relativeToConstraints
        )
    }
    
    func animate() {
        let isExpanded = model?.isExpanded ?? false
        contentLabel.isHidden = !isExpanded
        expandeImageView.image = isExpanded ? .arrowUp : .arrowDown
    }
}
