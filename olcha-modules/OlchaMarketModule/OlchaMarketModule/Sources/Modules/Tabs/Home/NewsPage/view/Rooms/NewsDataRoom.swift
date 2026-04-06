//
//  NewsDataRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//

import UIKit
import OlchaUI
class NewsDataRoom: BaseTableCell {

    
    private let dateLabel = UILabel()
    
    private let count = LeftIconButton()
    
    override func setupViews() {
        container.addSubview(dateLabel)
        container.addSubview(count)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 8
        
        dateLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        count.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.height.equalTo(24)
            make.left.equalTo(dateLabel.snp.right).inset(-8)
        }
    }
    
    override func configureViews() {
        dateLabel.style(.regular, 16)
        dateLabel.textColor = .olchaLightTextColornnnnnn
        
        count.setTitle("0")
        count.setIcon(.eye)
        count.titleLabel.style(.regular, 16)
        count.titleLabel.textColor = .olchaLightTextColornnnnnn
    }
    
    func setup(date: String, count: Int) {
        if let date = date.split(separator: " ").first {
            dateLabel.text = String(date) + " "
        }
        
        self.count.setTitle(count.string)
    }
}
