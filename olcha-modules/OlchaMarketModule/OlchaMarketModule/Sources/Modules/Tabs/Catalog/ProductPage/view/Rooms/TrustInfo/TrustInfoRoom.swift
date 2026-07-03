//
//  TrustInfoRoom.swift
//  OlchaMarketModule
//

import UIKit
import OlchaUI

// MARK: - Item View

private class TrustInfoItemView: UIView {
    private let iconContainer = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        iconContainer.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconContainer.snp.right).offset(12)
            make.right.equalToSuperview()
            make.bottom.equalTo(iconContainer.snp.centerY).offset(-1)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconContainer.snp.right).offset(12)
            make.right.equalToSuperview()
            make.top.equalTo(iconContainer.snp.centerY).offset(1)
        }

        iconContainer.layer.cornerRadius = 10
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.style(.semibold, 14)
        titleLabel.textColor = .olchaTextBlack

        subtitleLabel.style(.regular, 12)
        subtitleLabel.textColor = .olchaLightTextColornnnnnn
    }

    func configure(icon: UIImage?, iconTint: UIColor, iconBackground: UIColor, title: String, subtitle: String) {
        iconContainer.backgroundColor = iconBackground
        iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = iconTint
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

// MARK: - RoomView

class TrustInfoRoomView: BaseTableCellView {

    private let verifiedItem = TrustInfoItemView()
    private let supportItem = TrustInfoItemView()
    private let separator = UIView()

    override func setupViews() {
        container.addSubview(verifiedItem)
        container.addSubview(separator)
        container.addSubview(supportItem)
    }

    override func autolayout() {
        horizontalEdge = 0

        verifiedItem.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }

        separator.snp.makeConstraints { make in
            make.top.equalTo(verifiedItem.snp.bottom)
            make.left.equalToSuperview().inset(68)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(0.5)
        }

        supportItem.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(4)
        }
    }

    override func configureViews() {
        container.backgroundColor = .olchaWhite
        container.layer.cornerRadius = 12
        container.layer.masksToBounds = true

        separator.backgroundColor = UIColor.black.withAlphaComponent(0.06)

        verifiedItem.configure(
            icon: UIImage(systemName: "checkmark.shield.fill"),
            iconTint: .olchaGreen ?? .systemGreen,
            iconBackground: .olchaLightGreenGradient ?? UIColor.hex("#DDFCED"),
            title: "verified_product".localized(),
            subtitle: "only_verified_sellers".localized()
        )

        supportItem.configure(
            icon: UIImage(systemName: "headphones"),
            iconTint: .olchaOrange ?? .systemOrange,
            iconBackground: .olchaLightOrangeGradient ?? UIColor.hex("#FFF3E6"),
            title: "support_24_7".localized(),
            subtitle: "help_with_any_question".localized()
        )
    }
}
