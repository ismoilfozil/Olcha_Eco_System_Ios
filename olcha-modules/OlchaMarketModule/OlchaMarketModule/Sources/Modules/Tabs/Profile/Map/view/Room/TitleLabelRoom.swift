//
//  TitleLabelRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/09/22.
//

import UIKit
import OlchaUI
class TitleLabelRoom: BaseTableCell {

    
    private let titleLabel = UILabel()
    
    override func setupViews() {
        container.addSubview(titleLabel)
    }
    
    override func autolayout() {
        horizontalEdge = 2
        verticalEdge = 2
        
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configureViews() {
        titleLabel.style(.medium, 14)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.lineBreakMode = .byTruncatingTail
    }
        
    func setup(with data: String?) {
        titleLabel.text = (data ?? "").localized()
    }
}
