//
//  SuccessViewController.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 23/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import Lottie
import OlchaUtils

public class SuccessViewController: BaseViewController<EmptyNavigationBar> {
    
    public var closeObserver: (() -> Void)?
    
    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        animationView.loopMode = .autoReverse
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .olchaTextBlack
        return label
    }()
    
    private let closeButton: InvestOlchaButton = {
        let button = InvestOlchaButton()
        button.settings.setTitleColor(.lightGrayBackground, for: .normal)
        button.settings.titleLabel?.font = .style(.semibold, 16)
        button.round(10)
        return button
    }()
    
    public override func setupViews() {
        container.addSubview(animationView)
        container.addSubview(successLabel)
        container.addSubview(closeButton)
    }
    
    public override func autolayout() {
        animationView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-120)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        successLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(32)
        }
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    public override func configureViews() {
        closeButton.clicked { [weak self] in
            self?.closeObserver?()
        }
        guard let bundle = Bundle(identifier: BundleType.olchaInvestCore.identifier) else {
            return
        }
        animationView.animation = LottieAnimation.named("success", bundle: bundle)
        animationView.play()
        languageUpdated()
    }
    
    public override func languageUpdated() {
        successLabel.text = "success_text".localized(.olchaInvestCore)
        closeButton.setTitle("success_close".localized(.olchaInvestCore))
    }
    
//    public func setSuccessLabelText(_ amount: Double) {
//        successLabel.text = "На вашу карту успешно зачислено \(amount.string.originalPrice)"
//    }
    
}
