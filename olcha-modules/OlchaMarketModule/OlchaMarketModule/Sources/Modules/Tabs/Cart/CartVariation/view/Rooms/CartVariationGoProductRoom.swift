//
//  CartVariationGoProductRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 19/06/23.
//

import UIKit
import OlchaUI
import Combine

class CartVariationGoProductRoom: BaseTableCell {
    
    let actionButton: OlchaButton = {
        let button = OlchaButton()
        return button
    }()
    
    weak var goProductObserver: PassthroughSubject<Bool, Never>?
    weak var variationError: PassthroughSubject<Bool, Never>?
    weak var helper: VariationHelper?
    
    override func setupViews() {
        container.addSubview(actionButton)
    }
    
    override func autolayout() {
        actionButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.top.equalToSuperview()
        }
    }
    
    override func configureViews() {
        actionButton.clicked { [weak self] in
            guard let self = self else { return }
            guard Funcs.checkAvailableToBuy(
                selectedOptions: helper?.selectedOptions ?? [:],
                combinationOptions: helper?.combinationOptions ?? [:]) else {
                variationError?.send(true)
                return
            }
            goProductObserver?.send(true)
        }
    }
    
    public func setup(fullProduct: FullProductData?) {
        actionButton.setTitle("go_products".localized())
        actionButton.settings.requesting = (fullProduct == nil)
    }
    
}
