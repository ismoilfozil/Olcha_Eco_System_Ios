//
//  ImageCategoryItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/07/22.
//

import UIKit
import OlchaUI
class ImageCategoryItem: BaseCollectionCell {
    
    private let imageContainer = UIView()
    private let backgroundImageView = UIImageView()
    private let categoryImageView = UIImageView()
    private let categoryTitleLabel = UILabel()
    
    override func prepareForReuse() {
        backgroundImageView.image = nil
        categoryImageView.image = nil
        super.prepareForReuse()
    }
    
    override func setupViews() {
        
        self.container.addSubview(imageContainer)
        
        self.imageContainer.addSubview(backgroundImageView)
        self.imageContainer.addSubview(categoryImageView)
        
        self.container.addSubview(categoryTitleLabel)
        
    }
    
    override func autolayout() {
        
        self.imageContainer.snp.makeConstraints { make in
            make.left.right.greaterThanOrEqualToSuperview()
            make.width.lessThanOrEqualTo(96)
            
            make.height.equalTo(self.imageContainer.snp.width)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self.backgroundImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.categoryImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(16)
        }
        
        self.categoryTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageContainer.snp.bottom).inset(-8)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
    }
    
    override func configureViews() {
        self.container.backgroundColor = .clear
        self.imageContainer.round()
        

        self.categoryTitleLabel.numberOfLines = 0

        self.categoryTitleLabel.style(.medium, 12)
        self.categoryTitleLabel.textColor = .olchaTextBlack
        self.categoryTitleLabel.textAlignment = .center
        self.categoryTitleLabel.lineBreakMode = .byTruncatingTail
        
        self.backgroundImageView.contentMode = .scaleToFill
        
        self.backgroundImageView.backgroundColor = .olchaLightNeutralGray
    }
    
    func setup(with data: CategoryModel?, withBackgroundImage: Bool = true) {
        categoryTitleLabel.text = data?.getName()
        if withBackgroundImage {
            backgroundImageView.load(from: data?.background_image,
                                     withIndicator: false,
                                     quality: 3,
                                     imageType: .quadratic)
        } else {
            backgroundImageView.image = nil
            backgroundImageView.backgroundColor = .clear
        }
        categoryImageView.load(from: data?.main_image,
                               quality: 3,
                               imageType: .quadratic)
    }
}
