//
//  InvestProfitHistoryView.swift
//  OlchaInvestCore
//
//  Created by Elbek Khasanov on 11/05/24.
//  Copyright © 2024 Olcha. All rights reserved.
//

import UIKit
import OlchaUI

final class InvestProfitHistoryView: BaseView {
    private let container = UIView()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let statusContainer: UIView = {
        let view = UIView()
        view.round(6)
        return view
    }()
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let statusTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaWhite
        return label
    }()
    
    override func setupViews() {
        addSubview(container)
        container.addSubview(dateLabel)
        container.addSubview(priceLabel)
        container.addSubview(statusContainer)
        statusContainer.addSubview(statusImageView)
        statusContainer.addSubview(statusTitleLabel)
    }
    
    override func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.top.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(14)
            make.top.equalToSuperview().inset(12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).inset(-2)
            make.left.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(12)
        }
        
        statusContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(14)
            make.width.equalTo(112)
        }
        
        statusImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.bottom.equalToSuperview().inset(4)
            make.left.equalToSuperview().inset(6)
        }
        
        statusTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(statusImageView.snp.right).inset(-2)
            make.right.equalToSuperview().inset(6)
        }
    }
    
    override func configureViews() {
        container.backgroundColor = .lightGrayBackground
        container.round(14)
    }
    
    func setup(model: InvestProfitHistoryModel) {
        dateLabel.text = model.getDate()
        priceLabel.text = model.getPrice()
        statusContainer.backgroundColor = model.getStatus().color
        statusTitleLabel.text = model.getStatus().title
        statusImageView.image = model.getStatus().icon
    }
}
