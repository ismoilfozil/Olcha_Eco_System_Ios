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

class ExternalInstallmentRequirementModalPage: BaseModalViewController {

    var provider: ExternalInstallmentProvider?
    var continueAction: (() -> Void)?

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        return stack
    }()

    private let headerView = UIView()
    private let providerWrapper = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.bold, 20)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.text = "external_installment_requirement_title".localized()
        return label
    }()

    private let closeButton: IconButton = {
        let button = IconButton()
        button.setIcon(.x, edgeSize: 0, isIgnoringEdge: false)
        return button
    }()

    private let providerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .hex("#FAFAFA")
        view.round(28)
        return view
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let warningContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .hex("#FF7A00")
        view.round(24)
        view.border(with: .olchaWhite, width: 4)
        return view
    }()

    private let warningImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        imageView.tintColor = .olchaWhite
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 15)
        label.textColor = .hex("#4D4D4D")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .hex("#FFF8ED")
        view.round(12)
        view.border(with: .hex("#FFE0AD"), width: 1)
        return view
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .hex("#80694A")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private let continueButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("external_installment_requirement_continue".localized())
        button.configure(type: .pay)
        button.settings.titleLabel?.style(.bold, 18)
        return button
    }()

    private let detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .hex("#F4F5F7")
        button.setTitleColor(.hex("#1F2937"), for: .normal)
        button.titleLabel?.style(.bold, 16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
        if let image = UIImage(systemName: "arrow.up.forward.square") {
            button.setImage(image, for: .normal)
            button.semanticContentAttribute = .forceRightToLeft
            button.tintColor = .hex("#6B7280")
            button.imageEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: -8)
        }
        return button
    }()

    override func setupViews() {
        container.addSubview(contentStack)

        contentStack.addArrangedSubview(headerView)
        contentStack.addArrangedSubview(providerWrapper)
        contentStack.addArrangedSubview(descriptionLabel)
        contentStack.addArrangedSubview(infoContainer)
        contentStack.addArrangedSubview(continueButton)
        contentStack.addArrangedSubview(detailsButton)

        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)
        providerWrapper.addSubview(providerContainer)
        providerContainer.addSubview(logoImageView)
        providerContainer.addSubview(warningContainer)
        warningContainer.addSubview(warningImageView)
        infoContainer.addSubview(infoLabel)
    }

    override func autolayout() {
        modalMainContainer.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().inset(100)
        }

        dismissTrackerContainer.snp.remakeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0)
        }

        modalHeaderTitle.snp.remakeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalTo(container.snp.top)
        }

        container.snp.remakeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIApplication.shared.bottomInset)
        }

        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }

        headerView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(56)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(44)
            make.right.equalToSuperview().inset(44)
        }

        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(4)
            make.width.height.equalTo(32)
        }

        providerWrapper.snp.makeConstraints { make in
            make.height.equalTo(112)
        }

        providerContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(112)
        }

        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(32)
        }

        warningContainer.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.right.bottom.equalToSuperview().inset(-6)
        }

        warningImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        infoLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        continueButton.snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        detailsButton.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }

    override func configureViews() {
        modalHeaderTitle.isHidden = true
        dismissTrackerContainer.isHidden = true
        xButton.isHidden = true
        fullBackgroundColor = .olchaWhite
        contentStack.setCustomSpacing(20, after: headerView)
        contentStack.setCustomSpacing(20, after: providerWrapper)
        contentStack.setCustomSpacing(16, after: descriptionLabel)
        contentStack.setCustomSpacing(24, after: infoContainer)
        setProviderData()
    }

    override func setupObservers() {
        closeButton.clicked { [weak self] in
            self?.dismiss(animated: true)
        }

        continueButton.clicked { [weak self] in
            guard let self else { return }
            dismiss(animated: true) {
                self.continueAction?()
            }
        }

        detailsButton.addTarget(self, action: #selector(detailsTapped), for: .touchUpInside)
    }

    private func setProviderData() {
        let providerName = provider?.name ?? provider?.alias ?? ""
        let format = "external_installment_requirement_description".localized()
        descriptionLabel.text = String(format: format, providerName, providerName)
        infoLabel.text = provider?.infoText?.isEmpty == false
            ? provider?.infoText
            : String(format: "external_installment_requirement_info".localized(), providerName, providerName)
        detailsButton.setTitle(String(format: "external_installment_requirement_details".localized(), providerName), for: .normal)

        if let logoUrl = provider?.logoUrl {
            logoImageView.load(from: logoUrl, withIndicator: false, imageType: .ignoreResize, withPlaceholder: false)
        }
    }

    @objc private func detailsTapped() {
        openURL(provider?.linkUrl)
    }
}
