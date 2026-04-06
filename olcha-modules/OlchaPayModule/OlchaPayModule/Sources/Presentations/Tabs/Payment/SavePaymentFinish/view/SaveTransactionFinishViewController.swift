//
//  SavePaymentFinishViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI
public class SaveTransactionFinishViewController: BaseViewController<EmptyNavigationBar> {

    private lazy var finishImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .success_payment
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 24)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.text = "payment_saved".localized()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var closeButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("close".localized())
        button.configure(type: .pay)
        return button
    }()

    public weak var coordinator: PaymentsCoordinatorProtocol?
    
    public override func setupViews() {
        
        container.addSubview(finishImageView)
        container.addSubview(titleLabel)
        container.addSubview(closeButton)
        
    }
    
    public override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        }
        
        finishImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).inset(-16)
            make.width.height.equalTo(72)
        }
        
        closeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-40)
            
        }
    }
    
    public override func setupObservers() {
        ignoreNavigationBar = true
        closeButton.clicked { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
