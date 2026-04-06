//
//  ProductFAQsHeaderRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/08/22.
//

import UIKit
import OlchaUI
class ProductFAQsHeaderRoom: BaseTableCell {
    
    private let titleLabel = UILabel()
    private let countValueLabel = UILabel()
    private let subtitleLabel = UILabel()
    let askQuestion = OlchaButton()
    
    override func setupViews() {
        
        
        container.addSubview(titleLabel)
        container.addSubview(countValueLabel)
        
        container.addSubview(subtitleLabel)
        container.addSubview(askQuestion)
        
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        countValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.left.equalTo(titleLabel.snp.right).inset(-8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        askQuestion.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-16)
            make.width.equalTo(138)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "product_questions".localized()
        
        countValueLabel.style(.semibold, 18)
        countValueLabel.textColor = .olchaLightTextColornnnnnn
        countValueLabel.text = 0.string
        countValueLabel.textAlignment = .left
        
        subtitleLabel.style(.medium, 14)
        subtitleLabel.textColor = .olchaTextBlack
        subtitleLabel.text = "faq_subtitle".localized()
        subtitleLabel.numberOfLines = 0
        
        askQuestion.setTitle("ask_question".localized())
    }
    
    
    func setup(with data: String) {
        self.countValueLabel.text = data
    }
}

class ProductFAQsHeaderRoomView: BaseTableCellView {
    
    private let titleLabel = UILabel()
    private let countValueLabel = UILabel()
    private let subtitleLabel = UILabel()
    let askQuestion = OlchaButton()
    
    override func setupViews() {
        
        
        container.addSubview(titleLabel)
        container.addSubview(countValueLabel)
        
        container.addSubview(subtitleLabel)
        container.addSubview(askQuestion)
        
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        countValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.left.equalTo(titleLabel.snp.right).inset(-8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        askQuestion.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-16)
            make.width.equalTo(138)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "product_questions".localized()
        
        countValueLabel.style(.semibold, 18)
        countValueLabel.textColor = .olchaLightTextColornnnnnn
        countValueLabel.text = 0.string
        countValueLabel.textAlignment = .left
        
        subtitleLabel.style(.medium, 14)
        subtitleLabel.textColor = .olchaTextBlack
        subtitleLabel.text = "faq_subtitle".localized()
        subtitleLabel.numberOfLines = 0
        
        askQuestion.setTitle("ask_question".localized())
    }
    
    
    func setup(with data: String) {
        self.countValueLabel.text = data
    }
}
