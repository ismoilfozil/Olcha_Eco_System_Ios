//
//  ComponentHeader.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/08/22.
//

import UIKit
import Combine
import OlchaUI
class ComponentHeader: BaseTableCell {
        
    let responder = ComponentHeaderView()
    
    override func prepareForReuse() {
        responder.banner.image = nil
        responder.banner.backgroundColor = .lightGrayBackground
        super.prepareForReuse()
    }
    
    override func setupViews() {
        container.addSubview(responder)
    }
    
    override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setup(with model: ComponentModel?) {
        responder.setup(with: model)
    }
    
    func configure( with type: ComponentHeaderView.PromotedRoomType) {
        responder.configure(with: type)
    }
}
