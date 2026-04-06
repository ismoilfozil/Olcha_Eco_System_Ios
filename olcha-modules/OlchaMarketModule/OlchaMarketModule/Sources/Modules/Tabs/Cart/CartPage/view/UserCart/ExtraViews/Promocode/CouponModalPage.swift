//
//  PromocodeModalPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 08/02/24.
//

import OlchaUI
import UIKit

class CouponModalPage: BaseModalViewController {
    
    private let couponField: LightField = {
        let field = LightField()
        field.topHint = "use_coupon".localized()
        return field
    }()
    
    private let saveButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("save".localized())
        return button
    }()
    
    weak var observers: CartObservers?
    
    weak var checkoutViewModel: CheckoutViewModel?
    
    override func setupViews() {
        container.addSubview(couponField)
        container.addSubview(saveButton)
    }
    
    override func autolayout() {
        couponField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(couponField.snp.bottom).inset(-20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        xButton.isHidden = true
    }

    override func setupObservers() {
        saveButton.clicked { [weak self] in
            guard let self else { return }
            observers?.action.checkCoupon.send(couponField.getValue())
        }
        
        couponField.observeTextChanged { [weak self] in
            guard let self else { return }
            checkButtonState()
        }
    }
    
    
    override func setupOptionalObservers() {
        couponField.setValue(string: observers?.coupon?.code)
        guard let checkoutViewModel else { return }
        
        handle(checkoutViewModel.$coupon,
               success: { [weak self] data in
            guard let self else { return }
            showDefaultAlert(title: data?.isActiveTitle(),
                             content: data?.message) {
                self.dismiss(animated: true)
            }
        }, failure: { [weak self] error in
            guard let self else { return }
            
            showDefaultAlert(title: error?.isActiveTitle(),
                             content: error?.message)
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            saveButton.settings.requesting = isLoading
        })
    }
    
    override func setupOptionalInitialRequests() {
        checkButtonState()
    }
    
    private func checkButtonState() {
        (couponField.getText().withoutWhiteSpace == "") ? saveButton.disableButton() : saveButton.enableButton()
    }
}
