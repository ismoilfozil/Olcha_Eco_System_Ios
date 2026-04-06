//
//  NewsTitleRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//

import UIKit
import OlchaUI
class NewsTitleRoom: BaseTableCell {

    let newsTitle = UILabel()

    override func setupViews() {
        container.addSubview(newsTitle)
    }
    
    override func autolayout() {
        newsTitle.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        newsTitle.style(.bold, 18)
        newsTitle.textColor = .olchaTextBlack
        newsTitle.numberOfLines = 0
    }
    
    func setup(with data: String) {
        newsTitle.text = data
    }
    
}
