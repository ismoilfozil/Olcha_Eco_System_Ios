//
//  CircleCartButton.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 03/11/23.
//

import UIKit
import SnapKit
public class CircleCartButton: CartButton {
    
    public override func setupViews() {
        countButton = CircleBasketCounterButton()
        simpleButton = CircleSimpleCartButton()
        parentButton = CircleSimpleCartButton()
        soldButton = CircleSimpleCartButton()
        super.setupViews()
    }
    
    public override func configureViews() {
        super.configureViews()
        container.alignment = .bottom
        container.distribution = .equalSpacing
        cartContainer.alignment = .bottom
        cartContainer.distribution = .equalSpacing
        
        soldButton.alpha = 0.5
        
    }
 
    public override func autolayout() {
        super.autolayout()
        
        container.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(34)
        }
    }
}
