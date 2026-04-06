//
//  NewsContentRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//

import UIKit
import Atributika
import OlchaUI
class NewsContentRoom: BaseTableCell {

    private let content = AttributedLabel()
    
    override func setupViews() {
        container.addSubview(content)
    }
    
    override func autolayout() {
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        content.numberOfLines = 0
    }
    
    func setup(with data: String) {
        let updatedHTML = data
            .replacingOccurrences(of: "</p>", with: "</p>\n")
            .replacingOccurrences(of: "<br>", with: "<br>\n")
        
        content.attributedText = updatedHTML
            .style(tags: styleAllTags())
    }
    
    private func styleAllTags() -> [Style] {
//        let all = Style.font(.style(.medium, 16))
//        let strong = Style("strong").font(.style(.semibold, 16))
//
        return []
    }
}
