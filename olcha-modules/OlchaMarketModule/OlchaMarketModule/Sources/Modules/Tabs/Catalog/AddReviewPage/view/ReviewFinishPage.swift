//
//  ReviewFinishPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/08/22.
//

import UIKit
import OlchaUtils
import Lottie
import OlchaUI
class ReviewFinishPage: BaseViewController {
    
    private let animationView = LottieAnimationView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let doneButton = OlchaButton()
    
    var reviewType: ReviewType = .review
    var mainType: ReviewMainType = .main
    
    weak var coordinator: ReviewCoordinatorProtocol?
    
    var lastPage: UIViewController.Type?
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(animationView)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(doneButton)
        
    }
    
    override func autolayout() {
        super.autolayout()
        animationView.snp.makeConstraints { make in
            make.width.height.equalTo(180)
            make.top.equalToSuperview().inset(180)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(animationView.snp.bottom)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-32)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        
        titleLabel.style(.bold, 22)
        titleLabel.textColor = .olchaTextBlack
        titleLabel.numberOfLines = 0
        
        titleLabel.text = (reviewType == .review) ? "".localized() : "".localized()
        
        titleLabel.textAlignment = .center
        
        subtitleLabel.style(.medium, 14)
        subtitleLabel.textColor = .olchaTextBlack
        subtitleLabel.text = (reviewType == .review) ? "".localized() : "".localized()
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        
        
        doneButton.setTitle("go_products".localized())
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .autoReverse
        
        setupAnimation()
        
        animationView.play()
        
        switch (reviewType, mainType) {
            case (.review, .main):
                titleLabel.text = "thanks_review".localized()
                subtitleLabel.text = "thanks_review_subtitle".localized()
                break
            case (.question, .main):
                titleLabel.text = "thanks_question".localized()
                subtitleLabel.text = "thanks_question_subtitle".localized()
                break
            case (.review, .reply):
                titleLabel.text = "thanks_review".localized()
                subtitleLabel.text = "thanks_review_subtitle".localized()
                break
            case (.question, .reply):
                titleLabel.text = "thanks_asking".localized()
                subtitleLabel.text = "".localized()
                break
        }
    }
    
    private func setupAnimation() {
        guard let bundle = Bundle(identifier: BundleType.olchaMarketModule.identifier) else { return }
        animationView.animation = LottieAnimation.named(MarketTexts.animation_success,
                                                        bundle: bundle)
    }
    
    override func setupObservers() {
        super.setupObservers()
        doneButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.dismissToProductPage(lastPage: lastPage)
        }
    }
    
}
