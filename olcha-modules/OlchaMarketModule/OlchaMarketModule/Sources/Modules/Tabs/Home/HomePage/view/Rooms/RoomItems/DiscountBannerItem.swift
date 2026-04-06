//
//  DiscountBannerItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/07/22.
//

import UIKit
import SnapKit
import OlchaUI
class DiscountBannerItem: BaseCollectionCell {

    
    private let discountImageView = UIImageView()
    
    override func setupViews() {
        
        self.container.addSubview(discountImageView)
    }
    
    override func autolayout() {
        
        self.discountImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        self.container.backgroundColor = .olchaLightNeutralGray
        
        container.round()
    }

    
    func setup(with data: Discount?) {
        let url: String?  = data?.getMainMobileImage()
        discountImageView.load(from: url)
    }
}
