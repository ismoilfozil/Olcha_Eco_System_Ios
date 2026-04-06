//
//  ProductReviewItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//

import UIKit
import Cosmos
import Combine
import OlchaUI
class ProductMainFAQItem: BaseTableCell {
    
    let responder = FAQMainViewResponder()
    
    override func setupViews() {
        container.addSubview(responder)
    }
    
    override func autolayout() {
        responder.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
//            $0.height.equalTo(300)
        }
    }
    
}
