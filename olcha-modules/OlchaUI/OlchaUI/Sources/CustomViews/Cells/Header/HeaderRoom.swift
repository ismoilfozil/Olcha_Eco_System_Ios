//
//  HeaderRoom.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 12/05/23.
//

import UIKit

public class HeaderRoom: BaseTableCell {
    
    public let responder = HeaderView()

    public override func setupViews() {
        container.addSubview(responder)
    }
    
    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

public class HeaderItem: BaseCollectionCell {
    
    public let responder = HeaderView()

    public override func setupViews() {
        container.addSubview(responder)
    }
    
    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
