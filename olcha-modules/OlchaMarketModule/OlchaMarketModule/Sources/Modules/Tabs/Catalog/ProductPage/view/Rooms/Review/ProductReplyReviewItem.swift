//
//  ProductReplyReviewItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/03/23.
//

import UIKit
import OlchaUI
class ProductReplyReviewItem: BaseTableCell {

    let responder = ReviewReplyViewResponder()
    
    override func setupViews() {
        container.addSubview(responder)
    }
    
    override func autolayout() {
        responder.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
        }
    }
    
}
