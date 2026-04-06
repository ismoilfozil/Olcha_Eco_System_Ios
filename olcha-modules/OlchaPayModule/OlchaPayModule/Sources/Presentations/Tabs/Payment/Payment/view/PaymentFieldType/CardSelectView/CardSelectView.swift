//
//  CardSelectView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 06/04/23.
//

import UIKit
import OlchaUI
public class CardSelectView: BaseView {
    
    private lazy var container: UIView = {
        let view = UIView()
        view.darkBorder()
        view.round()
        return view
    }()
    
    private lazy var titlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaAccentColor
        label.style(.medium, 12)
        return label
    }()
    
    private lazy var cardNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaTextBlack
        label.style(.medium, 16)
        return label
    }()
    
    private lazy var errorHintLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaAccentColor
        label.style(.medium, 10)
        label.text = ""
        return label
    }()
    
    private lazy var dropDownIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .arrow_down?.withColor(.black)
        return imageView
    }()
    
    public let button = IButton()
    
    public override func setupViews() {
        addSubview(container)
        addSubview(errorHintLabel)
        container.addSubview(titlesStackView)
        container.addSubview(dropDownIcon)
        titlesStackView.addArrangedSubview(titleLabel)
        titlesStackView.addArrangedSubview(cardNumberLabel)
        container.addSubview(button)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(72)
        }
        
        titlesStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        dropDownIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
            make.left.equalTo(titlesStackView.snp.right).inset(-8)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        errorHintLabel.snp.makeConstraints { make in
            make.right.bottom.left.equalToSuperview()
            make.top.equalTo(container.snp.bottom).inset(-4)
        }
        
    }
    
    public func setup(card: UserBankCardModel?) {
        errorStyle(isError: card == nil)
        guard let card = card else {
            return
        }
        
        titleLabel.text = card.cardName
        
        cardNumberLabel.text = card.bank_card?.balance?.string.originalPriceDouble
        
    }
    
    func errorStyle(isError: Bool) {
        errorHintLabel.text = isError ? "card_not_selected".localized() : ""
    }
}
