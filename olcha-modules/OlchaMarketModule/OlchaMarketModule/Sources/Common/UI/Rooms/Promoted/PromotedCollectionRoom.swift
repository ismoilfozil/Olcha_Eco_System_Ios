//
//  PromotedCollectionRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/09/22.
//

import UIKit
import OlchaUI
class PromotedCollectionRoom: BaseCollectionCell {

    let responder = HorizontalPromotedRoomView()
    
    override func setupViews() {
        container.addSubview(responder)
    }
    
    override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        backgroundColor = .clear
    }
    
    func setup(with data: ProductsData?, maximumLimit: Int = 0) {
        responder.setup(with: data, maximumLimit: maximumLimit)
    }
    
    func configure(style: PromotedRoomView.ProductCellStyle,
                   withShowAll: Bool = false,
                   cellType: ProductCell.CellType,
                   space: CGFloat = 0.0) {
        responder.configure(style: style,
                            withShowAll: withShowAll,
                            cellType: cellType,
                            space: space)
    }
    
}
