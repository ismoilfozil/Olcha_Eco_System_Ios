//
//  NewsCardItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/07/22.
//

import UIKit
import OlchaUI
class NewsCardItem: BaseCollectionCell {
    
    
    private let newsImageView = UIImageView()
    
    private let dateContainer = UIView()
    
    private let dateLabel = UILabel()
    
    private let count = LeftIconButton()
    
    private let newsTitle = UILabel()
    
    private let newsContent = UILabel()
    
    private let height: CGFloat = 184
    
    override func prepareForReuse() {
        newsImageView.image = nil
        super.prepareForReuse()
    }
    
    override func setupViews() {
        container.addSubview(newsImageView)
        container.addSubview(dateContainer)
        dateContainer.addSubview(dateLabel)
        dateContainer.addSubview(count)
        container.addSubview(newsTitle)
        container.addSubview(newsContent)
    }
    
    override func autolayout() {
        
        newsImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(184)
        }
        
        dateContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(newsImageView.snp.bottom).inset(-8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        count.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.height.equalTo(24)
            make.left.equalTo(dateLabel.snp.right).inset(-8)
        }
        
        newsTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(dateContainer.snp.bottom).inset(-8)
        }
        
        newsContent.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(newsTitle.snp.bottom).inset(-8)
        }
    }
    
    override func configureViews() {
        newsImageView.round(8)
        newsImageView.backgroundColor = .olchaLightNeutralDarkGray
        
        newsTitle.style(.bold, 16)
        newsTitle.textColor = .olchaTextBlack
        newsTitle.numberOfLines = 2
        
        newsContent.style(.regular, 14)
        newsContent.textColor = .olchaLightTextColornnnnnn
        newsContent.numberOfLines = 3
        
        dateLabel.style(.regular, 14)
        dateLabel.textColor = .olchaLightTextColornnnnnn
        
        count.setTitle("0")
        count.setIcon(.eye)
        count.titleLabel.style(.regular, 14)
        count.titleLabel.textColor = .olchaLightTextColornnnnnn
    }
    
    func setup(with data: Blog) {
        newsTitle.text = data.getTitle()
        
        if let date = (data.created_at ?? "").split(separator: " ").first {
            dateLabel.text = String(date) + " "
        }
        
        self.count.setTitle((data.view_amount ?? 0).string)
        newsContent.text = data.getTrimmedDescription()
        newsImageView.load(from: data.getImage())
    }
}
