//
//  OnboardingNavigationBar.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import UIKit
import OlchaUI
public class OnboardingNavigationBar: BaseView {

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
        addSubview(skipButton)
    }
    
    public override func autolayout() {
        skipButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
    }
}
