//
//  AboutTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class AboutTableCell: BaseTableCell {
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 12
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let leftIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let rightIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .angleRightB
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16.0)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    public override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(leftIconImageView)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(rightIconImageView)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 6
        
        contentStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        [leftIconImageView, rightIconImageView].forEach { imageView in
            imageView.snp.makeConstraints { make in
                make.width.equalTo(24)
            }
        }
    }
    
    public override func configureViews() {
        container.round()
        container.backgroundColor = .lightGrayBackground
    }
    
    public func setup(with data: RowProtocol) {
        leftIconImageView.image = data.image
        titleLabel.text = data.title
    }

}
