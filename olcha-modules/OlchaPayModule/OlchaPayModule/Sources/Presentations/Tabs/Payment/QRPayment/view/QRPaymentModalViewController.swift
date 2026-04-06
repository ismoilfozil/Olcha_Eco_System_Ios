//
//  QRPaymentModalViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 02/03/23.
//

import UIKit
import OlchaUI
public class QRPaymentModalViewController: BaseModalViewController {
    
    private lazy var paymentContainer: UIView = {
        let view = UIView()
        view.round()
        view.darkBorder()
        return view
    }()
    
    private lazy var paymentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.round(8)
        imageView.contentMode = .scaleAspectFit
        imageView.image = .makro
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.textColor = .olchaTextBlack
        label.text = "Касса Makro.uz"
        return label
    }()
    
    private lazy var paymentField: TField = {
        let field = TField()
        field.topHint = "enter_payment".localized()
        field.type = .amount
        return field
    }()
    
    private lazy var nextButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("next".localized())
        button.configure(type: .pay)
        return button
    }()
    
    weak var coordinator: PaymentsCoordinatorProtocol?
    
    var qrURL: String? {
        didSet {
            titleLabel.text = qrURL
        }
    }
    
    public override func setupViews() {
        container.addSubview(paymentContainer)
        paymentContainer.addSubview(paymentImageView)
        paymentContainer.addSubview(titleLabel)
        container.addSubview(paymentField)
        container.addSubview(nextButton)
    }
    
    public override func autolayout() {
        paymentContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        paymentImageView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(16)
            make.width.height.equalTo(65)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview().inset(16)
            make.left.equalTo(paymentImageView.snp.right).inset(-16)
        }
        
        paymentField.snp.makeConstraints { make in
            make.top.equalTo(paymentContainer.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
            make.top.equalTo(paymentField.snp.bottom).inset(-16)
        }
    }
    
    public override func configureViews() {
        dismissConfiguration()
        setHeader(title: "pay_with_qr".localized())
    }

}
