//
//  FooterItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 21/07/22.
//

import UIKit

public class FooterItem: BaseTableCell {
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
