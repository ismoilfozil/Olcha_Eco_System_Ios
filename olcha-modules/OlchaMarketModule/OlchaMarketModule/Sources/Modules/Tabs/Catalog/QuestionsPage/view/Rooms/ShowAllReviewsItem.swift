//
//  ShowAllReviewsItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 21/07/22.
//

import UIKit
import OlchaUI
class ShowAllReviewsItem: BaseTableCell {
    
    private let title = UILabel()
    private let value = UILabel()
    private let icon = UIImageView()
    
    var withEdge = false {
        didSet {
            updateLayout()
        }
    }
    
    override func setupViews() {
        self.container.addSubview(title)
        self.container.addSubview(value)
        self.container.addSubview(icon)
    }
    
    var type: ReviewType = .review {
        didSet {
            self.title.text = (type == .review) ? "see_all_reviews".localized() : "see_all_faqs".localized()
        }
    }
    
    override func autolayout() {
        
        updateLayout()
        
        self.title.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        self.value.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.title.snp.right).inset(-8)
        }
        
        self.icon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureViews() {
        self.container.round(8)
        self.container.backgroundColor = .olchaLightNeutralGray
        
        self.title.text = "see_all_reviews".localized()
        self.title.style(.medium, 14)
        self.title.textColor = .olchaTextBlack
        
        self.value.textColor = .olchaLightTextColornnnnnn
        self.value.style(.medium, 14)
        
        self.icon.image = .rightIcon
    }
    
    func setup(with data: String) {
        self.value.text = data
    }
 
    
    func updateLayout() {
        self.container.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(withEdge ? 16 : 0)
        }
    }
}
