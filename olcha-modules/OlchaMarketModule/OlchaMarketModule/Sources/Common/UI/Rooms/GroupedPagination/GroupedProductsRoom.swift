//
//  GroupedProductsRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 16/05/23.
//

import UIKit
import OlchaUI
public class GroupedProductsRoom: BaseTableCell {

    public var responder = GroupedProductsView()
    
    public override func setupViews() {
        container.addSubview(responder)
    }
    
    public override func autolayout() {
        responder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
