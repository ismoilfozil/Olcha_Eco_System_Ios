//
//  AnonymReviewRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/03/23.
//

import UIKit
import OlchaUI
class AnonymReviewRoom: BaseTableCell {

    private let titleLabel = UILabel()
    let checkBox = IconButton()
    
    var isAnonym: Bool = false {
        didSet {
            anonymUpdated()
        }
    }
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(checkBox)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            
            make.left.equalToSuperview().inset(16)
        }
        
        checkBox.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        titleLabel.style(.semibold, 14)
        titleLabel.text = "review_anonym".localized()
        titleLabel.textColor = .olchaTextBlack
        
        isAnonym = false
    }
    
    func anonymUpdated() {
        checkBox.setIcon(isAnonym ? .checked : .unchecked, isIgnoringEdge: true)
    }
}
