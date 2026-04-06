//
//  CardFillRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/09/22.
//

import UIKit
import OlchaUI

public class CardFillRoom: BaseTableCell {

    let cardFill = CardFillView()
    
    public override func setupViews() {
        container.addSubview(cardFill)
    }
    
    public override func autolayout() {
        cardFill.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {}
    
    
}
