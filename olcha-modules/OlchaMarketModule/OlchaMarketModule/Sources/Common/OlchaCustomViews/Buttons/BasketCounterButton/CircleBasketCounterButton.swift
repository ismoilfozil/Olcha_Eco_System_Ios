//
//  CircleBasketCounterButton.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 03/11/23.
//

import UIKit

public class CircleBasketCounterButton: BasketCounterButton {
    
    private let plusMinusSize: CGFloat = 26
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints { make in
            make.width.height.equalTo(plusMinusSize)
            make.top.equalToSuperview().inset(2)
            make.centerX.equalToSuperview()
        }
        
        countTitle.snp.makeConstraints { make in
            make.top.equalTo(minusButton.snp.bottom).inset(-6)
            make.left.right.equalToSuperview().inset(2)
            make.bottom.equalTo(plusButton.snp.top).inset(-6)
        }
        
        plusButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(2)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(plusMinusSize)
            
        }
    }
    
    public override func configureViews() {
        super.configureViews()
        container.round(17)
        container.border(width: 0)
        container.backgroundColor = .hex("#EFEFEF")
        
        minusButton.setIcon(.cart_minus)
        plusButton.setIcon(.cart_plus)
        
        minusButton.backgroundColor = .olchaWhite
        minusButton.round(plusMinusSize / 2)
        
        plusButton.backgroundColor = .olchaWhite
        plusButton.round(plusMinusSize / 2)
        
        
        countTitle.style(.bold, 12)
        countTitle.textColor = .olchaAccentColor
    }
    
    public override func enableMinus() {
        minusButton.setIcon(.cart_minus)
    }
    
    public override func enablePlus() {
        plusButton.setIcon(.cart_plus)
    }
    
    public override func disablePlus() {
        plusButton.setIcon(.cart_plus?.withColor(.gray))
    }
    
    public override func disableMinus() {
        minusButton.setIcon(.cart_minus?.withColor(.gray))
    }
    
}
