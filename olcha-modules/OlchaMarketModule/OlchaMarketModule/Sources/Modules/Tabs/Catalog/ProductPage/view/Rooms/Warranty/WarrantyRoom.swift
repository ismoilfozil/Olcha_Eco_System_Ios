//
//  WarrantyRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/07/22.
//

import UIKit
import OlchaUI

class WarrantyRoom: BaseTableCell {

    
    private let warrantyIcon = UIImageView()
    private let warrantyTitle = UILabel()
    
    
    override func setupViews() {
        
        self.container.addSubview(warrantyIcon)
        self.container.addSubview(warrantyTitle)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        
        self.warrantyIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        self.warrantyTitle.snp.makeConstraints { make in
            make.left.equalTo(self.warrantyIcon.snp.right).inset(-8)
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    
    override func configureViews() {
        container.round()
        container.backgroundColor = .lightGrayBackground
        warrantyIcon.image = .warranty
        warrantyTitle.textColor = .olchaAccentColor
        warrantyTitle.style(.semibold, 16)

        
        warrantyTitle.text = "warranty".localized()
    }
    
    func setup(with data: String) {
        warrantyTitle.text = data
    }
}

class WarrantyRoomView: BaseTableCellView {

    
    private let warrantyIcon = UIImageView()
    private let warrantyTitle = UILabel()
    
    
    override func setupViews() {
        
        self.container.addSubview(warrantyIcon)
        self.container.addSubview(warrantyTitle)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        
        self.warrantyIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        self.warrantyTitle.snp.makeConstraints { make in
            make.left.equalTo(self.warrantyIcon.snp.right).inset(-8)
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    
    override func configureViews() {
        container.round()
        container.backgroundColor = .lightGrayBackground
        warrantyIcon.image = .warranty
        warrantyTitle.textColor = .olchaAccentColor
        warrantyTitle.style(.semibold, 16)

        
        warrantyTitle.text = "warranty".localized()
    }
    
    func setup(with data: String) {
        warrantyTitle.text = data
    }
}
