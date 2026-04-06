//
//  LimitView.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/06/23.
//
import UIKit
import OlchaUI
public class LimitView: BaseView {
    private let container = UIView()
    
    private let limitTitle = UILabel()
    
    private let idLabel = UILabel()
    
    private let moneyStack = UIStackView()
    
    public let addIcon = IconButton()
    
    private let moneyTitle = UILabel()
    
    
    public override func setupViews() {
        addSubview(container)
        container.addSubview(limitTitle)
        container.addSubview(idLabel)
        container.addSubview(moneyStack)
        moneyStack.addArrangedSubview(addIcon)
        moneyStack.addArrangedSubview(moneyTitle)
    }
        
    public override func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        limitTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
        }
        
        moneyStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        addIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
    }
    
    public override func configureViews() {
        container.round()
        container.backgroundColor = .olchaAccentColor
        
        limitTitle.style(.medium, 14)
        limitTitle.textColor = .olchaWhite
        limitTitle.text = "Olcha Limit"
        
        idLabel.style(.medium, 14)
        idLabel.textColor = .white
        
        addIcon.setIcon(.plus_circle)
        addIcon.isHidden = true
        
        moneyTitle.style(.bold, 24)
        moneyTitle.textColor = .white
        
        moneyStack.axis = .horizontal
        moneyStack.spacing = 8
    }
    
    public func setup(amount: String?, id: Int?) {
        if let id {
            idLabel.text = "ID: " + id.string
        }
        idLabel.isHidden = (id == nil)
        moneyTitle.text = amount?.originalPrice
    }

}
