//
//  SettingsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/10/22.
//

import UIKit
import Combine
import OlchaUI
class SettingsPage: BaseViewController {

    private let langContainer = UIView()
    private let langIcon = UIImageView()
    private let langTitle = UILabel()
    private let langValue = UILabel()
    private let langButton = Button()
    
    private let separator = Divide()
    
    private let pushContainer = UIView()
    private let pushIcon = UIImageView()
    private let pushTitle = UILabel()
    private let pushValue = UISwitch()
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    override func setupViews() {
        container.addSubview(langContainer)
        langContainer.addSubview(langIcon)
        langContainer.addSubview(langTitle)
        langContainer.addSubview(langValue)
        langContainer.addSubview(langButton)
        
        container.addSubview(separator)
        
        container.addSubview(pushContainer)
        pushContainer.addSubview(pushIcon)
        pushContainer.addSubview(pushTitle)
        pushContainer.addSubview(pushValue)
        
        
    }
    
    override func autolayout() {
        langContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        langIcon.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        langTitle.snp.makeConstraints { make in
            make.left.equalTo(langIcon.snp.right).inset(-8)
            make.top.bottom.equalToSuperview()
        }
        
        langValue.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        langButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(langContainer.snp.bottom).inset(-16)
        }
        
        
        
        pushContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(separator.snp.bottom).inset(-16)
        }
        
        pushIcon.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        pushTitle.snp.makeConstraints { make in
            make.left.equalTo(langIcon.snp.right).inset(-8)
            make.top.bottom.equalToSuperview()
        }
        
        pushValue.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }

    }
    
    override func configureViews() {
        navigation.configure(style: .back)
        
        langTitle.style(.medium, 16)
        langTitle.textColor = .olchaTextBlack
        
        
        langIcon.image = .globuse
        langValue.style(.medium, 16)
        langValue.textColor = .olchaAccentColor
        
        pushIcon.image = .notifications
        
        pushValue.onTintColor = .olchaAccentColor
        
        pushValue.isOn = OlchaGlobalDefaults.notification ?? true
        pushValue.addTarget(self,
                            action: #selector(pushObserver),
                            for: .valueChanged)
        languageUpdated()
    }
    
    override func setupObservers() {
        langButton.clicked { [weak self] in
            guard let self = self else { return }
            
            self.coordinator?.pushLanguagesPage()
        }
    }
    
    override func languageUpdated() {
        navigation.setTitle("settings".localized())
        langTitle.text = "app_language".localized()
        pushTitle.text = "push_notification".localized()
    }
    
    @objc private func pushObserver(_ sender: UISwitch) {
        OlchaGlobalDefaults.notification = sender.isOn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        langValue.text = "lang".localized()
    }
}
