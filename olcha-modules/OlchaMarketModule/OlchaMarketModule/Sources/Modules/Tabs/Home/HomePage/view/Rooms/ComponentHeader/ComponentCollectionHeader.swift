//
//  ComponentCollectionHeader.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/09/22.
//

import UIKit
import OlchaUI
class ComponentCollectionHeader: BaseCollectionCell {

    let responder = ComponentHeaderView()
    private var model: ComponentModel?
    
    
    override func setupViews() {
        container.addSubview(responder)
    }
    
    override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func setup(with model: ComponentModel?) {
        self.model = model
        responder.setup(with: model)
    }
    
    func configure( with type: ComponentHeaderView.PromotedRoomType) {
        responder.configure(with: type)
    }


}
