//
//  ShippingDataItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/07/22.
//

import UIKit
import OlchaUI

class ShippingDataItem: BaseTableCell {
    enum ItemStyle {
        case express
        case standard
        
        
        var header: String {
            switch self {
            case .express:
                return "express_shipping".localized()
            case .standard:
                return "standard_shipping".localized()
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .express:
                return .flash
            case .standard:
                return .truck_black
            }
        }
    }

    private let icon = UIImageView()
    private let headerTitle = UILabel()
    private let title = UILabel()
    
    override func setupViews() {
        
        container.addSubview(icon)
        container.addSubview(headerTitle)
        container.addSubview(title)
    }
    
    override func autolayout() {
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.left.equalToSuperview()
        }
        
        headerTitle.snp.makeConstraints { make in
            make.centerY.equalTo(self.icon.snp.centerY)
            make.left.equalTo(self.icon.snp.right).inset(-8)
            make.right.equalToSuperview().inset(16)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(self.icon.snp.bottom).inset(-4)
            make.left.equalTo(self.headerTitle.snp.left)
            make.right.equalToSuperview().inset(16)
            make.bottom.greaterThanOrEqualToSuperview().inset(16)
        }
        
    }
    
    override func configureViews() {
        container.backgroundColor = .clear
        headerTitle.style(.bold, 14)
        title.style(.medium, 14)
        headerTitle.textColor = .olchaTextBlack
        title.textColor = .olchaTextBlack
        title.numberOfLines = 0
        
    }
    
    func configure(style: ItemStyle) {
        headerTitle.text = style.header
        icon.image = style.icon
    }
    
    func setup(with data: Store?) {
        
        title.text = data?.getDeliveryInfo()
    }
}
