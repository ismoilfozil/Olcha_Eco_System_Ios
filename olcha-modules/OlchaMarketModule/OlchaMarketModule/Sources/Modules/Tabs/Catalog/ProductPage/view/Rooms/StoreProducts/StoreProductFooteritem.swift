//
//  StoreProductFooteritem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/07/22.
//

import UIKit
import OlchaUI
class StoreProductFooteritem: BaseTableCell {
    
    private let title = UILabel()
    let button = Button()
    
    
    override func setupViews() {
        container.addSubview(title)
        container.addSubview(button)
    }
    
    override func autolayout() {
        container.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(-2)
            make.height.equalTo(72)
        }
        
        title.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview().inset(16)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        clipsToBounds = true
        container.backgroundColor = .clear
        container.round(bottomCorner: true)
        container.border(with: .olchaLightNeutralGray, width: 1)
        
        title.style(.medium, 14)
        title.textColor = .olchaTextBlack
        title.round()
        title.textAlignment = .center
        title.backgroundColor = .olchaLightNeutralGray
        
    }
    
    func setup(with data: Int) {
        title.text = .lang("Все \(data) предложения продавцов",
                           "Барча \(data) та сотувчи таклифлари",
                           "Barcha \(data) ta sotuvchi takliflari")
        
    }
}

