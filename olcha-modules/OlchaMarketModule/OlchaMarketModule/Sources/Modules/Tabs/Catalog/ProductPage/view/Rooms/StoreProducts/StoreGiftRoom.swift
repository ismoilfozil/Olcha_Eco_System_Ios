//
//  StoreGiftRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/03/23.
//

import UIKit
import OlchaUI
class StoreGiftRoom: BaseTableCell {

    private let giftIcon = UIImageView()
    private let giftTitle = UILabel()
    
    override func setupViews() {
        container.addSubview(giftIcon)
        container.addSubview(giftTitle)
    }
    
    override func autolayout() {
        
        giftIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.top.equalToSuperview()
        }
        
        giftTitle.snp.makeConstraints { make in
            make.left.equalTo(giftIcon.snp.right).inset(-4)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    
    override func configureViews() {
        giftIcon.image = .gift_orange
        giftTitle.style(.bold, 14)
        giftTitle.textColor = .olchaOrange
        giftTitle.numberOfLines = 0
    }
    
    func setup(with data: ProductModel?) {
        giftTitle.text = "gift".localized() + " - " + (data?.getName() ?? "")
    }
    
}

class StoreGiftRoomView: BaseTableCellView {

    private let giftIcon = UIImageView()
    private let giftTitle = UILabel()
    
    override func setupViews() {
        container.addSubview(giftIcon)
        container.addSubview(giftTitle)
    }
    
    override func autolayout() {
        
        giftIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.top.equalToSuperview()
        }
        
        giftTitle.snp.makeConstraints { make in
            make.left.equalTo(giftIcon.snp.right).inset(-4)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    
    override func configureViews() {
        giftIcon.image = .gift_orange
        giftTitle.style(.bold, 14)
        giftTitle.textColor = .olchaOrange
        giftTitle.numberOfLines = 0
    }
    
    func setup(with data: ProductModel?) {
        giftTitle.text = "gift".localized() + " - " + (data?.getName() ?? "")
    }
    
}
