//
//  ProductReplyFAQItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/03/23.
//

import UIKit
import OlchaUI
class ProductReplyFAQItem: BaseTableCell {

    let responder = FAQReplyViewResponder()
    
    override func setupViews() {
        container.addSubview(responder)
    }
    
    override func autolayout() {
        responder.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
}
