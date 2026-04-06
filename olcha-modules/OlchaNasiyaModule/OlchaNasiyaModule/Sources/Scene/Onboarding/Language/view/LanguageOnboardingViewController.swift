////
////  LanguageOnboarding.swift
////  OlchaNasiyaModule
////
////  Created by Elbek Khasanov on 27/07/23.
////
//
//import UIKit
//import OlchaUI
//import ViewAnimator
//import OlchaUtils
//class LanguageOnboardingViewController: BaseViewController<EmptyNavigationBar> {
//    
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = .nasiya_logo
//        return imageView
//    }()
//    
//    private let buttonStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 12
//        stackView.isHidden = true
//        stackView.alpha = 0
//        return stackView
//    }()
//    
//    private let languages: [Language] = [
//        .ru,
//        .oz,
//        .uz
//    ]
//    
//    var completion: (() -> Void)?
//    
//    weak var coordinator: OnboardingCoordinatorProtocol?
//    
//    override func setupViews() {
//        container.addSubview(imageView)
//        container.addSubview(buttonStackView)
//    }
//    
//    override func autolayout() {
//        buttonStackView.snp.makeConstraints { make in
//            make.left.right.bottom.equalToSuperview().inset(16)
//        }
//        
//        imageView.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//            make.width.equalTo(128)
//            make.height.equalTo(45)
//        }
//    }
//    
//    override func configureViews() {
//        ignoreNavigationBar = true
//        buttonStackView.isHidden = true
//        createButtons()
//    }
//    
//    override func initialRequest() {
//        animateIcon { [weak self] in
//            guard let self = self else { return }
//            if (NasiyaGlobalDefaults.session.isEntered ?? false) {
//                coordinator?.finishOnboarding()
//            } else {
//                animateButtons()
//            }
//        }
//    }
//    
//    private func createButtons() {
//        for language in languages {
//            let button = getButton(language: language)
//            buttonStackView.addArrangedSubview(button)
//            button.snp.makeConstraints { $0.left.right.equalToSuperview() }
//        }
//    }
//    
//    private func getButton(language: Language) -> UIView {
//        let buttonContainer = UIView()
//        buttonContainer.round()
//        buttonContainer.backgroundColor = .lightGrayBackground
//        
//        let buttonIcon = UIImageView()
//        buttonIcon.image = getIcon(language: language)
//        
//        let buttonTitle = UILabel()
//        buttonTitle.textColor = .olchaTextBlack
//        buttonTitle.style(.semibold, 16)
//        buttonTitle.text = getTitle(language: language)
//
//        let button = IButton()
//        
//        buttonContainer.addSubview(buttonIcon)
//        buttonContainer.addSubview(buttonTitle)
//        buttonContainer.addSubview(button)
//        
//        buttonTitle.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview().inset(16)
//            make.centerX.equalToSuperview()
//        }
//        
//        buttonIcon.snp.makeConstraints { make in
//            make.width.equalTo(28)
//            make.height.equalTo(20)
//            make.right.equalTo(buttonTitle.snp.left).inset(-8)
//            make.centerY.equalToSuperview()
//        }
//        
//        button.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        button.clicked { [weak self] in
//            guard let self = self else { return }
//            languageSelected(language: language)
//        }
//        
//        return buttonContainer
//    }
//    
//    private func languageSelected(language: Language) {
//        String.setAppLanguage(language.rawValue)
//        String.setAppLanguage(for: NasiyaTexts.groupBundle, language.rawValue)
//        completion?()
//    }
//    
//    private func animateIcon(completion: (() -> Void)?) {
//        imageView.animate(animations: [AnimationType.zoom(scale: 4)], delay: 0, duration: 1) {
//            completion?()
//        }
//    }
//    
//    private func animateButtons() {
//        buttonStackView.isHidden = false
//        UIView.animate(withDuration: 1) { [weak self] in
//            guard let self = self else { return }
//            buttonStackView.alpha = 1
//        }
//    }
//    
//    private func getIcon(language: Language) -> UIImage? {
//        switch language {
//        case .ru:
//            return .ru_flag
//        case .uz:
//            return .uz_flag
//        case .oz:
//            return .uz_flag
//        }
//    }
//    
//    private func getTitle(language: Language) -> String {
//        switch language {
//        case .ru:
//            return "Русский язык"
//        case .uz:
//            return "Ўзбек тили"
//        case .oz:
//            return "O’zbek tili"
//        }
//    }
//    
//}
