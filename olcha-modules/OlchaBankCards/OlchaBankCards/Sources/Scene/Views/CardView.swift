//
//  CardView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/09/22.
//


import UIKit
import OlchaUI

public class CardView: BaseView {
    
    private let container = UIView()
    
    public let menuButton = IconButton()
    
    private let cardLogo = UIImageView()
    
    private let logo = UIImageView()
    
    private let nameTitle = UILabel()
    
    private let cardNumberTitle = UILabel()
    
    private let expireTitle = UILabel()
    
    private let menuButtonsContainer = UIStackView()
    
    private let menuContainer = UIStackView()
    
    public let makeDefaultButton = IButton()
    
    public let deleteButton = LeftIconButton()
    
    public var menuOpen: ((Int) -> Void)?
    
    public var isShown = false {
        didSet {
            menuContainer.isHidden = !isShown
        }
    }
    
    public var card: BankCard?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(cardLogo)
        container.addSubview(menuButton)
        container.addSubview(nameTitle)
        container.addSubview(cardNumberTitle)
        container.addSubview(expireTitle)
        addSubview(menuButtonsContainer)
        container.addSubview(menuContainer)
        menuContainer.addArrangedSubview(makeDefaultButton)
        menuContainer.addArrangedSubview(deleteButton)
    }
    
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview()
        }
        
        cardLogo.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20)
            make.bottom.equalTo(nameTitle.snp.top).inset(-24)
        }
        
        menuButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        nameTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(cardNumberTitle.snp.top).inset(-20)
        }
        
        cardNumberTitle.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview().inset(20)
        }
        
        expireTitle.snp.makeConstraints { make in
            make.centerY.equalTo(cardNumberTitle)
            make.left.equalTo(cardNumberTitle.snp.right).inset(-20)
        }
     
        menuContainer.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(menuButton.snp.bottom).inset(-4)
            make.height.lessThanOrEqualTo(72)
            make.width.equalTo(184)
        }
    }
    
    public override func configureViews() {
        container.round()
        container.border(width: 2.0)
        
        nameTitle.style(.semibold, 14)
        cardNumberTitle.style(.semibold, 14)
        expireTitle.style(.semibold, 14)
        
        nameTitle.textColor = .olchaTextBlack
        cardNumberTitle.textColor = .olchaTextBlack
        expireTitle.textColor = .olchaTextBlack
        
        menuButton.setIcon(.menu)
        
        cardLogo.image = UIImage()
        
        menuContainer.backgroundColor = .olchaWhite
        menuContainer.darkBorder()
        menuContainer.round()
        menuContainer.axis = .vertical
        menuContainer.distribution = .fillEqually
        
        makeDefaultButton.titleLabel?.style(.medium, 14)
        makeDefaultButton.setTitle("make_default".localized(), for: .normal)
        makeDefaultButton.setTitleColor(.olchaTextBlack, for: .normal)
        
        deleteButton.setIcon(.trash_blue?.withColor(.olchaAccentColor), iconSize: 20)
        deleteButton.setTitle("delete_card".localized())
        deleteButton.titleLabel.textColor = .olchaAccentColor
        
        isShown = false
        
        menuButton.clicked { [weak self] in
            guard let self = self, let id = self.card?.id else { return }
            self.menuOpen?(id)
        }
    }
    
    public func setup(with data: BankCard?) {
        card = data
        nameTitle.text = data?.full_name ?? " "
        cardNumberTitle.text = (data?.card_number ?? "").makeReadableCardNumber.hideCardNumber
        expireTitle.text = (data?.card_expiry ?? "").makeReadableExpireDateForCard
        
        cardLogo.image = (data?.card_number?.starts(with: "8600") ?? true) ? .uzcard : .humo
    }
    
    public func checkDefault() {
        if (card?.is_default ?? false) == true {
            makeDefaultButton.isHidden = true
            container.border(with: .olchaAccentColor, width: 2.0)
        } else {
            makeDefaultButton.isHidden = false
            container.border(width: 2.0)
        }
    }
    
    public func checkSelection( isSelected: Bool) {
        if isSelected {
            container.border(with: .olchaAccentColor, width: 2.0)
        } else {
            container.border(width: 2.0)
        }
    }
}
