//
//  CreditRequirementModalPage.swift
//  OlchaMarketModule
//
//  Created on 05/04/26.
//

import UIKit
import OlchaUI
import SnapKit

class CreditRequirementModalPage: BaseModalViewController {

    var continueAction: (() -> Void)?
    weak var coordinator: CartCoordinatorProtocol?

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()

    private let oneidImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = .resolve(named: "oneid")
        return iv
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 13)
        label.textColor = .olchaLightTextColornnnnnn
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "credit_requirement_subtitle".localized()
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 15)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "credit_requirement_description".localized()
        return label
    }()

    private let downloadLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 15)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        label.text = "credit_requirement_download".localized()
        return label
    }()

    private let storeButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    private let appStoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  App Store", for: .normal)
        button.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        button.tintColor = .olchaTextBlack
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = (UIColor.olchaLightNeutralGray ?? .lightGray).cgColor
        button.layer.cornerRadius = 8
        return button
    }()

    private let googlePlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Google Play", for: .normal)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .olchaTextBlack
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = (UIColor.olchaLightNeutralGray ?? .lightGray).cgColor
        button.layer.cornerRadius = 8
        return button
    }()

    private let guideButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("credit_requirement_guide".localized(), for: .normal)
        button.setTitleColor(.olchaAccentColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return button
    }()

    private let orderButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("credit_requirement_order".localized())
        return button
    }()

    override func setupViews() {
        container.addSubview(contentStack)

        contentStack.addArrangedSubview(oneidImageView)
        contentStack.addArrangedSubview(subtitleLabel)
        contentStack.addArrangedSubview(descriptionLabel)
        contentStack.addArrangedSubview(downloadLabel)
        contentStack.addArrangedSubview(storeButtonsStack)
        contentStack.addArrangedSubview(guideButton)
        contentStack.addArrangedSubview(orderButton)

        storeButtonsStack.addArrangedSubview(appStoreButton)
        storeButtonsStack.addArrangedSubview(googlePlayButton)
    }

    override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }

        oneidImageView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(80)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }

        storeButtonsStack.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(16)
        }

        orderButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }

    override func configureViews() {
        setHeader(title: "credit_requirement_title".localized())

        contentStack.setCustomSpacing(8, after: oneidImageView)
        contentStack.setCustomSpacing(20, after: subtitleLabel)
        contentStack.setCustomSpacing(20, after: descriptionLabel)
        contentStack.setCustomSpacing(12, after: downloadLabel)
        contentStack.setCustomSpacing(16, after: storeButtonsStack)
        contentStack.setCustomSpacing(16, after: guideButton)
    }

    override func setupObservers() {
        appStoreButton.addTarget(self, action: #selector(appStoreTapped), for: .touchUpInside)
        googlePlayButton.addTarget(self, action: #selector(googlePlayTapped), for: .touchUpInside)
        guideButton.addTarget(self, action: #selector(guideTapped), for: .touchUpInside)

        orderButton.clicked { [weak self] in
            guard let self else { return }
            dismiss(animated: true) {
                self.continueAction?()
            }
        }
    }

    @objc private func appStoreTapped() {
        openURL("https://apps.apple.com/uz/app/oneid-mobile/id1617964681")
    }

    @objc private func googlePlayTapped() {
        openURL("https://play.google.com/store/apps/details?id=uz.egov.oneId")
    }

    @objc private func guideTapped() {
        dismiss(animated: true) { [weak self] in
            self?.coordinator?.pushWebPage(urlString: "https://olcha.uz/oneid-guide",
                                           title: "credit_requirement_guide".localized())
        }
    }
}
