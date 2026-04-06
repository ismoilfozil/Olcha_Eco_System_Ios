//
//  PayAllRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/10/22.
//

import UIKit
import OlchaUI
class PayAllRoom: BaseTableCell {
    
    private let titleLabel = UILabel()
    
    private let priceField = TField()
    
    let payButton = OlchaButton()
    
    private let payAllButton = Button()
    
    weak var observer: OrderPaymentObserver? {
        didSet {
            priceField.setValue(string: observer?.payment)
            checkButtonState()
        }
    }
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(priceField)
        container.addSubview(payButton)
        container.addSubview(payAllButton)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 16
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
        }
        
        priceField.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-16)
            make.height.equalTo(40)
        }
        
        payButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(priceField.snp.top)
            make.height.equalTo(40)
            make.left.equalTo(priceField.snp.right).inset(-8)
            make.width.equalTo(100)
        }
        
        payAllButton.snp.makeConstraints { make in
            make.top.equalTo(payButton.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
    
    override func configureViews() {
        titleLabel.style(.bold, 18)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.text = "amount_to_pay".localized()
        
        priceField.type = .amount
        
        payButton.setTitle("pay".localized())
        
        payAllButton.setTitle("pay_all_button".localized(), for: .normal)
        payAllButton.setTitleColor(.olchaWhite, for: .normal)
        payAllButton.round()
        payAllButton.backgroundColor = .olchaTextBlack
        payAllButton.titleLabel?.style(.medium, 14)
        
        payAllButton.clicked { [weak self] in
            guard let self = self else { return }
            self.observer?.payment = self.observer?.totalPayment ?? ""
            self.observer?.tableReloader.send(true)
        }
        
        priceField.observeText { [weak self] in
            guard let self = self else { return }
            self.observer?.payment = self.priceField.getValue()
        }
        
        container.round()
        container.border()
    }

    private func checkButtonState() {
        (observer?.selectedPayment == .default) ? payButton.disableButton() : payButton.enableButton()
    }
    
}
