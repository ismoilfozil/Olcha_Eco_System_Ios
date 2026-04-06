//
//  BankCardRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/09/22.
//

import UIKit
import OlchaUI
public class BankCardRoom: BaseTableCell {

    public let card = CardView()
    
    public override func setupViews() {
        container.addSubview(card)
    }
    
    public override func autolayout() {
        card.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func setup(with data: BankCard?) {
        card.setup(with: data)
    }
    
}
