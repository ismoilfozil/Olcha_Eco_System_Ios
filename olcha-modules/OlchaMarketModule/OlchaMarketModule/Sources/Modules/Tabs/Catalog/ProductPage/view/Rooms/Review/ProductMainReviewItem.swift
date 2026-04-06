//
//  FAQRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/08/22.
//

import UIKit
import Cosmos
import OlchaUI
import Combine
class ProductMainReviewItem: BaseTableCell {
    let responder = ReviewMainViewResponder()
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
