//
//  OnboardingNavigationBar.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import OlchaUI
public class OnboardingNavigationBar: BaseView {

    private let languageButton: IconButton = {
        let button = IconButton()
        button.setIcon(.globuse, edgeSize: 24)
        button.icon.contentMode = .scaleAspectFit
        return button
    }()
    
    public let skipButton: RightIconButton = {
        let button = RightIconButton()
        button.configure(image: .rightIcon,
                         title: "skip".localized(),
                         size: 24,
                         padding: 4)
        button.buttonTitle.style(.medium, 16)
        return button
    }()

    public override func setupViews() {
        addSubview(languageButton)
        addSubview(skipButton)
    }
    
    public override func autolayout() {
        languageButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        skipButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
    }
    
    public override func languageUpdated() {
        skipButton.buttonTitle.text = "skip".localized()
    }
    
    public func languageButtonObserver(completion: @escaping () -> Void) {
        languageButton.clicked(action: completion)
    }
}
