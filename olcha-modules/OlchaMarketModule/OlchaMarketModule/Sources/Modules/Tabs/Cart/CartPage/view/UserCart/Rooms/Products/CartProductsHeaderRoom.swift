//
//  CartProductsHeaderRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/09/22.
//

import UIKit
import OlchaUI
class CartProductsHeaderRoom: BaseTableCell {
    
    let headerView = GuestCartHeaderView()
    
    override func setupViews() {
        container.addSubview(headerView)
    }
    
    override func autolayout() {
        container.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {

        headerView.backgroundColor = .white
    }
    
    func setup(isChecked: Bool) {
        headerView.setup()
        headerView.isSelected = isChecked
    }
}
