//
//  GiftInfoModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/07/22.
//

import UIKit

class GiftInfoModalPage: BaseViewController {
    private let headerTitle = UILabel()
    private let contentTitle = UILabel()
    override func viewDidLoad() {
        setupModalViews()
        modalAutolayout()
        configureModalViews(header: "product_gift".localized())
    }
    
    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(headerTitle)
        modalContainer.addSubview(contentTitle)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        contentTitle.snp.makeConstraints { make in
            make.left.right.equalTo(headerTitle)
            make.top.equalTo(headerTitle.snp.bottom).inset(-16)
            make.bottom.equalToSuperview().inset(24)
        }
        
    }
    
    override func configureModalViews(header: String, textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        
        dismissConfiguration()
        contentTitle.style(.medium, 16)
        contentTitle.textColor = .olchaTextBlack
        contentTitle.text = "product_gift_content".localized()
        contentTitle.numberOfLines = 0
    }
    
    
}
