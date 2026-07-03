//
//  CartItemRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 01/02/24.
//

import UIKit
import OlchaUI

enum RightImageView {
    case anchor
    case radio
    case cancel
    case empty
}

class CartItemRoom: BaseTableCell {
    
    enum ItemState {
        case `default`
        case success
        case error
    }
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 14
//        stackView.distribution = .equalCentering
        stackView.alignment = .center
        return stackView
    }()
    
    private let titlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
//        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaNeutral700
        return label
    }()
    
    private let valueStackView: UIView = {
        let stackView = UIView()
//        stackView.axis = .horizontal
//        stackView.spacing = 4
//        stackView.alignment = .leading
//        stackView.distribution = .fill
        return stackView
    }()
    
    private let valueImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let inlineValueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()

    private let inlinePrefixLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let inlineLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let inlineSuffixLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let titleLabelContainer = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = ""
        return label
    }()
    
    let infoButton: IconButton = {
        let button = IconButton()
        button.setIcon(.cart_info)
        return button
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaLightTextColornnnnnn
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    public let radioButton: IconButton = {
        let button = IconButton()
        button.setIcon(.radio_switch_off)
        return button
    }()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .rightIcon?.withColor(.olchaLightTextColornnnnnn ?? .gray)
        return imageView
    }()
    
    public let cancelButton: IconButton = {
        let button = IconButton()
        button.setIcon(.cancel_circle)
        return button
    }()
    
    public var isChosen: Bool = false {
        didSet {
            radioButton.isHidden = false
            rightImageView.isHidden = true
            radioButton.setIcon(isChosen ? .radio_switch_on : .radio_switch_off )
        }
    }
    
    override func setupViews() {
        container.addSubview(contentStackView)
        contentStackView.addArrangedSubview(leftImageView)
        contentStackView.addArrangedSubview(titlesStackView)
        contentStackView.addArrangedSubview(radioButton)
        contentStackView.addArrangedSubview(rightImageView)
        contentStackView.addArrangedSubview(cancelButton)
        
        titlesStackView.addArrangedSubview(headerLabel)
        titlesStackView.addArrangedSubview(valueStackView)
        valueStackView.addSubview(titleLabelContainer)
        titleLabelContainer.addSubview(titleLabel)
        titleLabelContainer.addSubview(infoButton)
        valueStackView.addSubview(valueImageView)
        valueStackView.addSubview(inlineValueStackView)
        inlineValueStackView.addArrangedSubview(inlinePrefixLabel)
        inlineValueStackView.addArrangedSubview(inlineLogoImageView)
        inlineValueStackView.addArrangedSubview(inlineSuffixLabel)
        titlesStackView.addArrangedSubview(subtitleLabel)
    }
    
    override func autolayout() {
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(10)
            make.height.greaterThanOrEqualTo(44)
        }
        
        leftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }

        valueStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        titleLabelContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
        
        infoButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).inset(-4)
            make.width.height.equalTo(16)

            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        valueImageView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }

        inlineValueStackView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }

        inlineLogoImageView.snp.makeConstraints { make in
            make.width.equalTo(54)
            make.height.equalTo(18)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        radioButton.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(20)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
    }
    
    override func configureViews() {
        container.backgroundColor = CartStyle.whiteColor
        backgroundColor = CartStyle.backgroundColor
        radioButton.clicked { [weak self] in
            guard let self else { return }
        }
    }
    
    func setup(section: UserCartPage.Section,
               showState: Bool = false,
               rightImageType: RightImageView = .anchor,
               subtitle: String? = nil,
               value: String? = nil,
               valueImageURL: String? = nil,
               valueImage: UIImage? = nil,
               inlineImageSuffix: String? = nil
    ) {
        leftImageView.image = section.icon
        setup(section: section,
              valueTitle: value,
              valueImageURL: valueImageURL,
              valueImage: valueImage,
              inlineImageSuffix: inlineImageSuffix)
        setup(subtitle: subtitle)

        
        setup(state: showState ? ((value == nil && valueImageURL == nil) ? .error : .success) : .default,
              rightImageType: rightImageType)
    }
    
    private func setup(state: ItemState, rightImageType: RightImageView) {
        setup(rightImageType: rightImageType)
        switch state {
        case .default:
            container.backgroundColor = .olchaWhite
        case .success:
            rightImageView.image = .finished
            container.backgroundColor = .olchaWhite
        case .error:
            rightImageView.image = .error
            container.backgroundColor = .olchaAccentColor.withAlphaComponent(0.2)
        }
    }

    private func setup(rightImageType: RightImageView) {
        [rightImageView, radioButton, cancelButton].forEach { $0.isHidden = true }
        switch rightImageType {
        case .anchor:
            rightImageView.image = .rightIcon?.withColor(.olchaLightTextColornnnnnn ?? .gray)
            rightImageView.isHidden = false
        case .radio:
            radioButton.isHidden = false
        case .cancel:
            cancelButton.isHidden = false
        case .empty:
            break
        }
    }
    
    private func setup(section: UserCartPage.Section,
                       valueTitle: String?,
                       valueImageURL: String?,
                       valueImage: UIImage?,
                       inlineImageSuffix: String?) {
        valueImageView.isHidden = true
        titleLabelContainer.isHidden = true
        inlineValueStackView.isHidden = true

        headerLabel.isHidden = true
        headerLabel.text = section.header

        if !valueTitle.isNillOrEmpty, !valueImageURL.isNillOrEmpty, !inlineImageSuffix.isNillOrEmpty {
            headerLabel.isHidden = false
            inlineValueStackView.isHidden = false
            inlinePrefixLabel.text = "\(valueTitle ?? "") ("
            inlineLogoImageView.isHidden = false
            inlineLogoImageView.load(from: valueImageURL, withIndicator: false, imageType: .ignoreResize, withPlaceholder: false)
            inlineSuffixLabel.text = " × \(inlineImageSuffix ?? "") )"
            enableInlineValueConstraints()
        } else if !valueTitle.isNillOrEmpty, valueImage != nil, !inlineImageSuffix.isNillOrEmpty {
            headerLabel.isHidden = false
            inlineValueStackView.isHidden = false
            inlinePrefixLabel.text = "\(valueTitle ?? "") ("
            inlineLogoImageView.isHidden = false
            inlineLogoImageView.image = valueImage
            inlineSuffixLabel.text = " × \(inlineImageSuffix ?? "") )"
            enableInlineValueConstraints()
        } else if !valueTitle.isNillOrEmpty, !inlineImageSuffix.isNillOrEmpty {
            headerLabel.isHidden = false
            inlineValueStackView.isHidden = false
            inlinePrefixLabel.text = "\(valueTitle ?? "")"
            inlineLogoImageView.isHidden = true
            inlineSuffixLabel.text = " · \(inlineImageSuffix ?? "")"
            enableInlineValueConstraints()
        } else if !valueImageURL.isNillOrEmpty {
            headerLabel.isHidden = false
            valueImageView.isHidden = false
            valueImageView.load(from: valueImageURL)
            enableValueImageConstraints()
        } else if !valueTitle.isNillOrEmpty {
            headerLabel.isHidden = false
            titleLabelContainer.isHidden = false
            titleLabel.text = valueTitle
            disableValueImageConstraints()
        } else {
            titleLabelContainer.isHidden = false
            titleLabel.text = section.title
            disableValueImageConstraints()
        }

        infoButton.isHidden = !section.info
    }
    
    private func setup(subtitle: String? = nil) {
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = (subtitle == nil)
    }
    
    private func enableValueImageConstraints() {
        inlineValueStackView.snp.removeConstraints()
        valueImageView.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
    }

    private func disableValueImageConstraints() {
        valueImageView.snp.removeConstraints()
        inlineValueStackView.snp.removeConstraints()
    }

    private func enableInlineValueConstraints() {
        valueImageView.snp.removeConstraints()
        inlineValueStackView.snp.remakeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
    }
}
