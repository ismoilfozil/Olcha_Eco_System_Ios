//
//  FooterCollectionItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 14/12/22.
//

import UIKit


public class FooterCollectionItem: BaseCollectionCell {
    public let responder = FooterView()
    public override func setupViews() {
        container.addSubview(responder)
    }
    
    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
