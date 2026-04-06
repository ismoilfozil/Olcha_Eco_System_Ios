//
//  CardView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/09/22.
//


import UIKit
import OlchaUI
import OlchaUtils

public protocol CardProtocol: AnyObject {
    func getId() -> Int
    func getFullName() -> String
    func getNumber() -> String
    func getExpire() -> String
    func getLogoURL() -> String
    func getIsDefault() -> Bool
    func getAmount() -> Double
}

public class BillingCardView: BaseView {
    
    public let container : UIView = {
        let view = UIView()
        view.round()
        view.backgroundColor = .lightGrayBackground
        return view
    }()
    
    public let menuButton : IconButton = {
        let button = IconButton()
        button.setIcon(.menu)
        return button
    }()
    
    public let cardLogo : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public let nameTitle : UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaDarkNeutralGray
        label.text = "          "
        return label
    }()
    
    public let amountTitle : UILabel = {
        let label = UILabel()
        label.style(.semibold, 24)
        label.textColor = .olchaTextBlack
        label.text = "          "
        return label
    }()
    
    public let cardNumberTitle : UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.text = "          "
        return label
    }()
    
    public let expireTitle : UILabel = {
        let label = UILabel()
        label.style(.medium, 12)
        label.textColor = .olchaTextBlack
        label.text = "          "
        return label
    }()
    
    public let menuButtonsContainer = UIStackView()
    
    public let menuContainer : UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .olchaWhite
        view.darkBorder()
        view.round()
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    public let makeDefaultButton : IButton = {
        let button = IButton()
        button.titleLabel?.style(.medium, 14)
        button.setTitle("make_default".localized(), for: .normal)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        return button
    }()
    
    public let deleteButton : LeftIconButton = {
        let button = LeftIconButton()
        button.setIcon(.trash_blue?.withColor(.olchaAccentColor), iconSize: 20)
        button.setTitle("delete_card".localized())
        button.titleLabel.textColor = .olchaAccentColor
        return button
    }()
    
    public var menuOpen: ((Int) -> Void)?
    
    public var isShown = false {
        didSet {
            menuContainer.isHidden = !isShown
        }
    }
    
    public weak var card: CardProtocol?
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(cardLogo)
        container.addSubview(menuButton)
        container.addSubview(nameTitle)
        container.addSubview(amountTitle)
        container.addSubview(cardNumberTitle)
        container.addSubview(expireTitle)
        addSubview(menuButtonsContainer)
        container.addSubview(menuContainer)
        menuContainer.addArrangedSubview(makeDefaultButton)
        menuContainer.addArrangedSubview(deleteButton)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        menuButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        nameTitle.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.right.equalTo(menuButton.snp.left).inset(-8)
        }
        
        amountTitle.snp.makeConstraints { make in
            make.top.equalTo(nameTitle.snp.bottom).inset(-4)
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(menuButton.snp.left).inset(-8)
        }
        
        cardLogo.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(16)
            make.height.equalTo(32)
            make.width.equalTo(64)
        }
        
        cardNumberTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(cardLogo.snp.left).inset(-8)
            make.bottom.equalTo(expireTitle.snp.top).inset(-4)
        }
        
        expireTitle.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(16)
        }
     
        menuContainer.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(menuButton.snp.bottom).inset(-4)
            make.width.lessThanOrEqualTo(184)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        makeDefaultButton.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
    }
    
    public override func configureViews() {
        cardLogo.image = UIImage()
        isShown = false
        menuButton.clicked { [weak self] in
            guard let self = self,
                  let id = card?.getId() else { return }
            self.menuOpen?(id)
        }
    }
    
    public func reset() {
        checkSelection(isSelected: false)
        isShown = false
        card = nil
        nameTitle.text = nil
        cardNumberTitle.text = nil
        expireTitle.text = nil
        amountTitle.text = nil
        cardLogo.image = nil
    }
    
    public func setup(with data: CardProtocol?, currency: String? = nil) {
        card = data
        nameTitle.text = data?.getFullName() ?? " - "
        cardNumberTitle.text = (data?.getNumber() ?? "").makeReadableCardNumber.hideCardNumber
        expireTitle.text = (data?.getExpire() ?? "").makeReadableExpireDateForCard
        amountTitle.text = (data?.getAmount() ?? 0).string.originalPriceWithoutCurrency + " " + (currency ?? Texts.currency)
        cardLogo.load(from: data?.getLogoURL())
    }
    
    public func checkSelection(isSelected: Bool) {
        if isSelected {
            makeDefaultButton.isHidden = true
            container.border(with: .olchaAccentColor, width: 2.0)
        } else {
            makeDefaultButton.isHidden = false
            container.border(width: 2.0)
        }
    }
}
