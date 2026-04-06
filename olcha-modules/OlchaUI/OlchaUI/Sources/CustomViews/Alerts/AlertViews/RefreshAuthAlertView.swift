//
//  RefreshAuthAlertView.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 15/01/24.
//

import UIKit
public class RefreshAuthAlertView: BaseView {
    
    private let container = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .profile_person
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 20)
        label.numberOfLines = 0
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        label.text = "refresh_auth_expired".localized()
        return label
    }()
    
    private let loginButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("enter_profile".localized())
        return button
    }()
    
    private let xButton: IconButton = {
        let button = IconButton()
        button.setIcon(.x_cancel)
        return button
    }()
    
    weak var delegate: BaseAlertDelegate?
    public override func setupViews() {
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(imageView)
        container.addSubview(loginButton)
        container.addSubview(xButton)
    }
    
    public override func autolayout() {
        
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(60)
            make.width.height.equalTo(96)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.equalTo(imageView.snp.bottom).inset(-40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-60)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
     
        xButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
    }
    
    public override func configureViews() {
        
        container.backgroundColor = .white
        container.round()
        
        loginButton.clicked { [weak self] in
            guard let self = self else { return }
            self.delegate?.okClicked(dismiss: true)
        }
        
        xButton.clicked { [weak self] in
            guard let self else { return }
            self.delegate?.dismiss()
        }
    }
}
