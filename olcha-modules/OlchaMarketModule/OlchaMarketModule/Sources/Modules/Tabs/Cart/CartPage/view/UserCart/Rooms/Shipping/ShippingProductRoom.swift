//
//  ShippingProductRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/10/22.
//

import UIKit
import OlchaUI
class ShippingProductRoom: BaseTableCell {
    
    private let titleLabel = UILabel()
    
    private let table = BaseTableView()
    
    var shippingTypes: [Delivery] = []
    
    let itemHeight: CGFloat = 64.0
    
    weak var observers: CartObservers?
    
    var selectedShippingType: Delivery?
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(table)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        updateLayout()
    }
    
    override func configureViews() {
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: ShippingTypeRoom.self)
    }
    
    func setup(with data: [Delivery], selectedShippingType: Delivery?) {
        titleLabel.text = "type_ship".localized()
        self.selectedShippingType = selectedShippingType
        shippingTypes = data
        updateLayout()
    }
    
    private func updateLayout() {
        table.reloadData()
        table.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-12)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(itemHeight * shippingTypes.count.cgfloat)
        }
    }
}

class ShippingProductRoomView: BaseTableCellView {
    
    private let titleLabel = UILabel()
    
    private let table = BaseTableView()
    
    var shippingTypes: [Delivery] = []
    
    let itemHeight: CGFloat = 64.0
    
    weak var observers: CartObservers?
    
    var selectedShippingType: Delivery?
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(table)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        updateLayout()
    }
    
    override func configureViews() {
        titleLabel.style(.semibold, 24)
        titleLabel.textColor = .olchaTextBlack
        
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: ShippingTypeRoom.self)
    }
    
    func setup(with data: [Delivery], selectedShippingType: Delivery?) {
        titleLabel.text = "type_ship".localized()
        self.selectedShippingType = selectedShippingType
        shippingTypes = data
        updateLayout()
    }
    
    private func updateLayout() {
        table.reloadData()
        table.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-12)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(itemHeight * shippingTypes.count.cgfloat)
        }
    }
}
