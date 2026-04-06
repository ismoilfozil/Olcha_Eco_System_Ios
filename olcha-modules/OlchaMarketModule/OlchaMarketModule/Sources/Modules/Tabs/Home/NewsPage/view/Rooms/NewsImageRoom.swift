//
//  NewsImageRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//

import UIKit
import OlchaUI
class NewsImageRoom: BaseTableCell {
    
    private let newsImage = UIImageView()
    
    override func setupViews() {
        container.addSubview(newsImage)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 8
        
        newsImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(186)
        }
    }
    
    override func configureViews() {
        container.round(8)
    }
    
    func setup(with data: String) {
        newsImage.load(from: data)
    }
    
}
