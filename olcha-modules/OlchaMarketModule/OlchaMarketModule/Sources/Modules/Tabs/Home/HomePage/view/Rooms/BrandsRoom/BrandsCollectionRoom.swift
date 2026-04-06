//
//  BrandsCollectionRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/12/22.
//

import UIKit
import OlchaUI
class BrandsCollectionRoom: BaseCollectionCell {
    
    let responder: BrandsRoomView = BrandsRoomView()
    
    override func setupViews() {
        container.addSubview(responder)
    }
    
    override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        
    }
    
}
