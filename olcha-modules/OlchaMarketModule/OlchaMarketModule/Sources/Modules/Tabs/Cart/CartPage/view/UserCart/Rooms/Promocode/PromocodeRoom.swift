//
//  PromocodeRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/10/22.
//

import UIKit
import Combine
import OlchaUI
class PromocodeRoom: BaseTableCell {
    enum CouponState {
        case error(message: String)
        case success
        case none
    }
    
    let promocodeField: TField = {
        let field = TField()
        field.saveStates = true
        return field
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    let acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("accept".localized())
        button.disableButton()
        return button
    }()
    
    let cancelButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("cancel".localized())
        return button
    }()
    
    var currentState: CouponState = .none {
        didSet {
            couponState()
        }
    }
    
    override func setupViews() {
        container.addSubview(promocodeField)
        container.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(acceptButton)
        buttonsStackView.addArrangedSubview(cancelButton)
    }
    
    override func autolayout() {
        promocodeField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(buttonsStackView.snp.left).inset(-8)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(116)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
    }
    
    func setup(coupon: Coupon?) {
        promocodeField.placeholder = "fill_promocode".localized()
        acceptButton.setTitle("accept".localized())
        cancelButton.setTitle("cancel".localized())
        
        if let coupon = coupon {
            if (coupon.code ?? "") == "" {
                currentState = .error(message: coupon.message ?? "coupon_error".localized())
            } else {
                currentState = .success
            }
        } else {
            currentState = .none
        }
        
    }
    
    
    private func couponState() {
        print("current state is", currentState)
        switch currentState {
        case .error(let message):
            promocodeField.errorStyle(message)
            cancelButton.isHidden = true
            acceptButton.isHidden = false
            promocodeField.enableGrayView = false
        case .success:
            promocodeField.successStyle()
            cancelButton.isHidden = false
            acceptButton.isHidden = true
            promocodeField.enableGrayView = true
        case .none:
            promocodeField.defaultStyle()
            cancelButton.isHidden = true
            acceptButton.isHidden = false
            promocodeField.enableGrayView = false
        }
    }
}

class PromocodeRoomView: BaseTableCellView {
    enum CouponState {
        case error(message: String)
        case success
        case none
    }
    
    let promocodeField: TField = {
        let field = TField()
        field.saveStates = true
        return field
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    let acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("accept".localized())
        button.disableButton()
        return button
    }()
    
    let cancelButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("cancel".localized())
        return button
    }()
    
    var currentState: CouponState = .none {
        didSet {
            couponState()
        }
    }
    
    override func setupViews() {
        container.addSubview(promocodeField)
        container.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(acceptButton)
        buttonsStackView.addArrangedSubview(cancelButton)
    }
    
    override func autolayout() {
        promocodeField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(buttonsStackView.snp.left).inset(-8)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(116)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
    }
    
    func setup(coupon: Coupon?) {
        promocodeField.placeholder = "fill_promocode".localized()
        acceptButton.setTitle("accept".localized())
        cancelButton.setTitle("cancel".localized())
        
        if let coupon = coupon {
            if (coupon.code ?? "") == "" {
                currentState = .error(message: coupon.message ?? "coupon_error".localized())
            } else {
                currentState = .success
            }
        } else {
            currentState = .none
        }
        
    }
    
    
    private func couponState() {
        
        switch currentState {
        case .error(let message):
            promocodeField.errorStyle(message)
            cancelButton.isHidden = true
            acceptButton.isHidden = false
            promocodeField.enableGrayView = false
        case .success:
            promocodeField.successStyle()
            cancelButton.isHidden = false
            acceptButton.isHidden = true
            promocodeField.enableGrayView = true
        case .none:
            promocodeField.defaultStyle()
            cancelButton.isHidden = true
            acceptButton.isHidden = false
            promocodeField.enableGrayView = false
        }
    }
}
