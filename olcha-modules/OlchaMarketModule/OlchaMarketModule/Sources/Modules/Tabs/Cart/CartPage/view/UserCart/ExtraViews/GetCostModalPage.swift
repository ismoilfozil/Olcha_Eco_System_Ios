//
//  GetCostModalPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 06/02/24.
//

import UIKit
import OlchaUI

class GetCostModalPage: BaseModalViewController {
    
    private let responder: CartCostView = {
        let view = CartCostView()
        view.hideInfoButtons = true
        return view
    }()
    
    private let closeButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("understand".localized())
        return button
    }()
    
    weak var observers: CartObservers?
    var coupon: Coupon?
    
    override func setupViews() {
        container.addSubview(responder)
        container.addSubview(closeButton)
    }
    
    override func autolayout() {
        responder.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(30)
            make.bottom.equalTo(closeButton.snp.top).inset(-50)
        }
        
        closeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        xButton.isHidden = true
        setHeader(title: "overall_payment".localized())
    }
    
    override func setupObservers() {
        closeButton.clicked { [weak self] in
            guard let self else { return }
            dismiss(animated: true)
        }
    }
    
    override func setupOptionalObservers() {
        
        responder.setup(observers: observers,
                        costType: .full)
        
    }
    
}
