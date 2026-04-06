//
//  ProductsGiftRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/07/22.
//

import UIKit
import OlchaUI
class ProductsGiftRoom: BaseTableCell {
    
    private let giftIcon = UIImageView()
    private let giftTitle = UILabel()
    private let table = BaseTableView()
    
    let giftInfoButton = IconButton()

    var products: [ProductModel] = []
    
    let cellHeight: CGFloat = 80
    
    weak var productHelper: ProductHelper?
    
    override func setupViews() {
        self.container.addSubview(giftTitle)
        self.container.addSubview(giftIcon)
        self.container.addSubview(table)
        

        self.container.addSubview(giftInfoButton)
        
    }
    
    override func autolayout() {
        horizontalEdge = 16
        
        self.giftIcon.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        self.giftTitle.snp.makeConstraints { make in
            make.left.equalTo(self.giftIcon.snp.right).inset(-8)
            make.centerY.equalTo(self.giftIcon.snp.centerY)
        }
        
        self.giftInfoButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.right.equalToSuperview().inset(16)
            make.left.equalTo(self.giftTitle.snp.right).inset(-8)
        }
        
        self.table.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(giftIcon.snp.bottom).inset(-16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(0)
        }
    }
    
    override func configureViews() {
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.registerClass(forCell: GiftProductRoom.self)
        self.table.configure()
        
        self.giftIcon.image = .gift
        self.giftInfoButton.setIcon(.info)
        
        self.giftTitle.style(.bold, 16)
        self.giftTitle.textColor = .olchaTextBlack
        self.giftTitle.text = "gift_for_order".localized()
        
        self.container.round()
        self.container.border(with: .olchaLightNeutralDarkGray)
    }
    

    func setup(with data: [ProductModel]) {
        self.products = data
        updateLayout()
    }
    
    private func updateLayout() {
        table.snp.updateConstraints { make in
            make.height.equalTo(cellHeight * products.count.cgfloat)
        }
    }
    
}
class ProductsGiftRoomView: BaseTableCellView {
    
    private let giftIcon = UIImageView()
    private let giftTitle = UILabel()
    private let table = BaseTableView()
    
    let giftInfoButton = IconButton()

    var products: [ProductModel] = []
    
    let cellHeight: CGFloat = 80
    
    weak var productHelper: ProductHelper?
    
    override func setupViews() {
        self.container.addSubview(giftTitle)
        self.container.addSubview(giftIcon)
        self.container.addSubview(table)
        

        self.container.addSubview(giftInfoButton)
        
    }
    
    override func autolayout() {
        horizontalEdge = 16
        
        self.giftIcon.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        self.giftTitle.snp.makeConstraints { make in
            make.left.equalTo(self.giftIcon.snp.right).inset(-8)
            make.centerY.equalTo(self.giftIcon.snp.centerY)
        }
        
        self.giftInfoButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.right.equalToSuperview().inset(16)
            make.left.equalTo(self.giftTitle.snp.right).inset(-8)
        }
        
        self.table.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(giftIcon.snp.bottom).inset(-16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(0)
        }
    }
    
    override func configureViews() {
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.registerClass(forCell: GiftProductRoom.self)
        self.table.configure()
        
        self.giftIcon.image = .gift
        self.giftInfoButton.setIcon(.info)
        
        self.giftTitle.style(.bold, 16)
        self.giftTitle.textColor = .olchaTextBlack
        self.giftTitle.text = "gift_for_order".localized()
        
        self.container.round()
        self.container.border(with: .olchaLightNeutralDarkGray)
    }
    

    func setup(with data: [ProductModel]) {
        self.products = data
        updateLayout()
    }
    
    private func updateLayout() {
        table.snp.updateConstraints { make in
            make.height.equalTo(cellHeight * products.count.cgfloat)
        }
        table.reloadData()
    }
    
}
