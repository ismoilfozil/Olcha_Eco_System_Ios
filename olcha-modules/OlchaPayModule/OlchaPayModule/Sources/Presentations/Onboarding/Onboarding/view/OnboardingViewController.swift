//
//  OnboardingViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 14/02/23.
//

import UIKit
import OlchaUI
public class OnboardingViewController: BaseViewController<EmptyNavigationBar> {
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 16
        scrollView.settings.contentInset = .init(top: 16, left: 0, bottom: 100, right: 0)
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .onboarding_card
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 24)
        label.textColor = .olchaTextBlack
        label.text = "onboarding_title".localized()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.text = "onboarding_title".localized()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var skipButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.medium, 16)
        button.setTitle("skip".localized(), for: .normal)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        return button
    }()
    
    private lazy var addButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("link_card".localized())
        button.configure(type: .pay)
        return button
    }()
    
    public weak var coordinator: AddCardCoordinatorProtocol?
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(imageView)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(subtitleLabel)
        container.addSubview(skipButton)
        container.addSubview(addButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        skipButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top).inset(-16)
        }
        
        addButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(36)
        }
    }
    
    public override func configureViews() {
        
    }

    public override func setupObservers() {
        addButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushAddCard()
        }
        
        skipButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.completed?()
        }
    }
}
