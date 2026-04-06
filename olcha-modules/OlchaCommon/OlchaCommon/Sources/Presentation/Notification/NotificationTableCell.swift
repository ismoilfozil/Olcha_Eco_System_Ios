//
//  NotificationTableCell.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 29/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

public class NotificationTableCell: BaseTableCell {
    
    private let statusSize: CGFloat = 36
    
    private lazy var statusContainer: UIView = {
        let view = UIView()
        view.round(statusSize/2)
        return view
    }()
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.alignment = .firstBaseline
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 12)
        label.textColor = .olchaDarkNeutralGray
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaDarkNeutralGray
        label.numberOfLines = 0
        return label
    }()
        
    public override func setupViews() {
        container.addSubview(statusContainer)
        statusContainer.addSubview(statusImageView)
        container.addSubview(headerStackView)
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(dateLabel)
        
        container.addSubview(descriptionLabel)
    }
    
    public override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 6
        
        statusContainer.snp.makeConstraints { make in
            make.width.height.equalTo(statusSize)
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(12)
        }
        
        statusImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerX.centerY.equalToSuperview()
        }
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(statusContainer.snp.top)
            make.left.equalTo(statusContainer.snp.right).inset(-12)
            make.right.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(headerStackView.snp.left)
            make.right.equalTo(headerStackView.snp.right)
            make.top.equalTo(headerStackView.snp.bottom).inset(-8)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .olchaWhite
        container.round()
    }
    
    public func setup(with model: CommonNotificationModel) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        descriptionLabel.text = model.content

        statusContainer.backgroundColor = .hex(model.status_color ?? "")
        statusImageView.load(from: model.status_icon)
    }
    
}
