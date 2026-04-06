//
//  MainCardItem.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/02/23.
//

import UIKit
import OlchaUI
public class MainCardItem: BaseCollectionCell {
    
    private lazy var gradientContainer: GradientView = {
        let view = GradientView()
        view.round()
        view.backgroundColor = .orange
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 14)
        label.textColor = .olchaWhite.withAlphaComponent(0.5)
        label.text = "  "
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 28)
        label.textColor = .olchaWhite
        label.text = "  "
        return label
    }()
    
    private lazy var cardNumberLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 18)
        label.textColor = .olchaWhite
        label.text = "  "
        return label
    }()
    
    private lazy var bankNameLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaWhite
        label.text = "  "
        return label
    }()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public override func setupViews() {
        container.addSubview(gradientContainer)
        gradientContainer.addSubview(titleLabel)
        gradientContainer.addSubview(amountLabel)
        gradientContainer.addSubview(cardNumberLabel)
        gradientContainer.addSubview(bankNameLabel)
        gradientContainer.addSubview(icon)
    }
    
    public override func autolayout() {
        gradientContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.left.equalToSuperview().inset(16)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
        }
        
        cardNumberLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(amountLabel.snp.bottom).inset(-20)
            make.right.lessThanOrEqualTo(icon.snp.left).inset(-8)
        }
        
        bankNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(cardNumberLabel.snp.bottom).inset(-4)
            make.bottom.equalToSuperview().inset(24)
            make.right.equalTo(icon.snp.left).inset(-8)
        }
        
        icon.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
        
    }
    
    public func setup(card: UserBankCardModel) {
        
        titleLabel.text = "balance".localized() + ":"
        amountLabel.text = (card.bank_card?.balance ?? 0.0).string.originalPrice
        cardNumberLabel.text = card.bank_card?.getSpacedPan()
        bankNameLabel.text = card.bank_card?.full_name
        
        switch card.bank_card?.getType() {
        case .humo:
            icon.image = .humo?.withColor(.olchaWhite)
            break
        case .uzcard:
            icon.image = .uzcard?.withColor(.olchaWhite)
            break
        default:
            icon.image = .init()
            break
        }
        
        if let color = card.color {
            gradientContainer.backgroundColor = .hex(color)
        }
    }
}
