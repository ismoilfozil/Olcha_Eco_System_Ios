//
//  PromotedRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
import SnapKit
import Combine
import OlchaUI

class HorizontalPromotedRoom: BaseTableCell {
    let responder = HorizontalPromotedRoomView()

    override func setupViews() {
        container.addSubview(responder)
    }
    
    override func configureViews() {
        backgroundColor = .clear
    }
    
    override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
