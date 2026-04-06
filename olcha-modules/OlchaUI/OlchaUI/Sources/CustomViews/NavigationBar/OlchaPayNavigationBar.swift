//
//  OlchaPayNavigationBar.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 02/02/23.
//

import UIKit
public class OlchaPayNavigationBar: BaseView, BaseNavigationInput {
    public weak var delegate: BaseNavigationOutput?
    
    public lazy var notificationButton: IconButton = {
        let button = IconButton()
        button.setIcon(.notification?.withTintColor(.olchaWhite))
        return button
    }()
    
    public lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .olcha_pay
        return imageView
    }()
    
    public lazy var langButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.bold, 16)
        button.setTitleColor(.olchaWhite, for: .normal)
        button.setTitle("lang_short".localized(), for: .normal)
        return button
    }()
    
    public override func setupViews() {
        addSubview(notificationButton)
//        addSubview(icon)
        addSubview(langButton)
    }
    
    public override func autolayout() {
        notificationButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        langButton.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }

//        icon.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//            make.width.equalTo(80)
//            make.height.equalTo(24)
//        }
    }
    
    public override func configureViews() {
        backgroundColor = .clear
    }
    
    public override func languageUpdated() {
        langButton.setTitle("lang_short".localized(), for: .normal)
        
    }
}
