//
//  ShippingTypeRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/10/22.
//

import OlchaUI
import UIKit
class ShippingTypeRoom: BaseTableCell {

    private let titleLabel = UILabel()
    
    private let subtitle = UILabel()
    
    var isChosen: Bool = false {
        didSet {
            container.backgroundColor = isChosen ? .olchaAccentColor : .olchaWhite
            isChosen ? container.removeBorder() : container.darkBorder()
            titleLabel.textColor = isChosen ? .olchaWhite : .olchaTextBlack
            subtitle.textColor = isChosen ? .olchaWhite : .olchaLightTextColornnnnnn
        }
    }
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(subtitle)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 4
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
        }
        
        subtitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    override func configureViews() {
        container.round()
        container.darkBorder()
        
        titleLabel.style(.semibold, 14)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.numberOfLines = 0
        
        subtitle.style(.regular, 12)
        subtitle.textColor = .olchaLightTextColornnnnnn
        subtitle.numberOfLines = 0
    }
    
    func setup(with data: Delivery?) {
        titleLabel.text = (data?.getName() ?? "") + " - " + (data?.price?.string ?? "").price
        subtitle.text = data?.getDeliveredTime()
    }
}

class ShippingTypeRoomView: BaseTableCellView {

    private let titleLabel = UILabel()
    
    private let subtitle = UILabel()
    
    var isChosen: Bool = false {
        didSet {
            container.backgroundColor = isChosen ? .olchaAccentColor : .olchaWhite
            isChosen ? container.removeBorder() : container.darkBorder()
            titleLabel.textColor = isChosen ? .olchaWhite : .olchaTextBlack
            subtitle.textColor = isChosen ? .olchaWhite : .olchaLightTextColornnnnnn
        }
    }
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(subtitle)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 4
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
        }
        
        subtitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    override func configureViews() {
        container.round()
        container.darkBorder()
        
        titleLabel.style(.semibold, 14)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.numberOfLines = 0
        
        subtitle.style(.regular, 12)
        subtitle.textColor = .olchaLightTextColornnnnnn
        subtitle.numberOfLines = 0
    }
    
    func setup(with data: Delivery?) {
        titleLabel.text = (data?.getName() ?? "") + " - " + (data?.price?.string ?? "").price
        subtitle.text = data?.getDeliveredTime()
    }
}
