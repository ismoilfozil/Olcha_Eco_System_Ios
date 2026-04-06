//
//  CashAdRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/07/22.
//

import UIKit
import OlchaUI
class CashAdRoom: BaseTableCell {

    private let rankIcon = UIImageView()
    private let ballTitle = UILabel()
    
    
    private let premiumTitle = UILabel()
    private let premiumValue = UILabel()
    
    private let olchaWalletTitle = UILabel()
    private let olchaWalletValue = UILabel()
    
    
    override func setupViews() {
        self.container.addSubview(rankIcon)
        self.container.addSubview(ballTitle)
        self.container.addSubview(premiumTitle)
        self.container.addSubview(premiumValue)
        
        self.container.addSubview(olchaWalletTitle)
        self.container.addSubview(olchaWalletValue)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        
        self.rankIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(12)
            make.width.height.equalTo(20)
        }
        
        self.ballTitle.snp.makeConstraints { make in
            make.left.equalTo(self.rankIcon.snp.right).inset(-8)
            make.centerY.equalTo(self.rankIcon.snp.centerY)
            make.right.equalToSuperview().inset(12)
        }
        
        self.premiumTitle.snp.makeConstraints { make in
            make.top.equalTo(self.ballTitle.snp.bottom).inset(-8)
            make.left.equalTo(self.ballTitle.snp.left)
        }
        
        self.olchaWalletTitle.snp.makeConstraints { make in
            make.top.equalTo(self.premiumTitle.snp.bottom).inset(-4)
            make.left.equalTo(self.ballTitle.snp.left)
            make.bottom.equalToSuperview().inset(12)
        }
        
        self.premiumValue.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(self.premiumTitle.snp.top)
            make.left.equalTo(self.premiumTitle.snp.right).inset(-4)
        }
        
        self.olchaWalletValue.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(self.olchaWalletTitle.snp.top)
            make.left.equalTo(self.olchaWalletTitle.snp.right).inset(-4)
        }
        
    }
    
    override func configureViews() {
        self.rankIcon.image = .rank
        self.ballTitle.style(.medium, 14)
        self.ballTitle.textColor = .olchaOrange
        
        self.container.backgroundColor = .lightGrayBackground
        self.container.round()
        
        self.configurePremiumText()
        self.configureWalletText()
    }
    
    private func configurePremiumText() {
        self.premiumTitle.numberOfLines = 0
        self.premiumValue.numberOfLines = 0
        
        self.premiumTitle.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        self.premiumTitle.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        self.premiumValue.setContentHuggingPriority(.init(1000), for: .horizontal)
        self.premiumValue.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        self.premiumTitle.style(.medium, 14)
        self.premiumValue.style(.semibold, 14)
        
        
        
        
        
        let premiumString1: NSAttributedString = .init(string: "with_subscribe".localized(), attributes: [
            NSAttributedString.Key.font: UIFont.style(.medium, 14),
            NSAttributedString.Key.foregroundColor: UIColor.olchaTextBlack ?? .black])
        
        let premiumString2: NSAttributedString = .init(string: "Premium", attributes: [
            NSAttributedString.Key.font: UIFont.style(.medium, 14),
            NSAttributedString.Key.foregroundColor: UIColor.olchaAccentColor])
        
        let finalText = NSMutableAttributedString()
        finalText.append(premiumString1)
        finalText.append(premiumString2)
        
        self.premiumTitle.attributedText = finalText
    }
    
    private func configureWalletText() {
        
        self.olchaWalletTitle.numberOfLines = 0
        self.olchaWalletValue.numberOfLines = 0
        
        self.olchaWalletTitle.style(.medium, 14)
        self.olchaWalletValue.style(.semibold, 14)
        
        self.olchaWalletTitle.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        self.olchaWalletTitle.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        self.olchaWalletValue.setContentHuggingPriority(.init(1000), for: .horizontal)
        self.olchaWalletValue.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        
        
        
        let walletString1: NSAttributedString = .init(string: "on_payment".localized(), attributes: [
            NSAttributedString.Key.font: UIFont.style(.medium, 14),
            NSAttributedString.Key.foregroundColor: UIColor.olchaTextBlack ?? .black])
        
        let walletString2: NSAttributedString = .init(string: "witch_olcha_cash".localized(), attributes: [
            NSAttributedString.Key.font: UIFont.style(.medium, 14),
            NSAttributedString.Key.foregroundColor: UIColor.olchaAccentColor])
        
        
        
        
        let finalText = NSMutableAttributedString()
        finalText.append(walletString1)
        finalText.append(walletString2)
         
        
        self.olchaWalletTitle.attributedText = finalText
    }
    
    
    func setup(with data: String) {
        self.premiumValue.text = "234"
        self.olchaWalletValue.text = "541"
        self.ballTitle.text = "Получите до 448 балла"
    }
}
class CashAdRoomView: BaseTableCellView {

    private let rankIcon = UIImageView()
    private let ballTitle = UILabel()
    
    
    private let premiumTitle = UILabel()
    private let premiumValue = UILabel()
    
    private let olchaWalletTitle = UILabel()
    private let olchaWalletValue = UILabel()
    
    
    override func setupViews() {
        self.container.addSubview(rankIcon)
        self.container.addSubview(ballTitle)
        self.container.addSubview(premiumTitle)
        self.container.addSubview(premiumValue)
        
        self.container.addSubview(olchaWalletTitle)
        self.container.addSubview(olchaWalletValue)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        
        self.rankIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(12)
            make.width.height.equalTo(20)
        }
        
        self.ballTitle.snp.makeConstraints { make in
            make.left.equalTo(self.rankIcon.snp.right).inset(-8)
            make.centerY.equalTo(self.rankIcon.snp.centerY)
            make.right.equalToSuperview().inset(12)
        }
        
        self.premiumTitle.snp.makeConstraints { make in
            make.top.equalTo(self.ballTitle.snp.bottom).inset(-8)
            make.left.equalTo(self.ballTitle.snp.left)
        }
        
        self.olchaWalletTitle.snp.makeConstraints { make in
            make.top.equalTo(self.premiumTitle.snp.bottom).inset(-4)
            make.left.equalTo(self.ballTitle.snp.left)
            make.bottom.equalToSuperview().inset(12)
        }
        
        self.premiumValue.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(self.premiumTitle.snp.top)
            make.left.equalTo(self.premiumTitle.snp.right).inset(-4)
        }
        
        self.olchaWalletValue.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(self.olchaWalletTitle.snp.top)
            make.left.equalTo(self.olchaWalletTitle.snp.right).inset(-4)
        }
        
    }
    
    override func configureViews() {
        self.rankIcon.image = .rank
        self.ballTitle.style(.medium, 14)
        self.ballTitle.textColor = .olchaOrange
        
        self.container.backgroundColor = .lightGrayBackground
        self.container.round()
        
        self.configurePremiumText()
        self.configureWalletText()
    }
    
    private func configurePremiumText() {
        self.premiumTitle.numberOfLines = 0
        self.premiumValue.numberOfLines = 0
        
        self.premiumTitle.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        self.premiumTitle.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        self.premiumValue.setContentHuggingPriority(.init(1000), for: .horizontal)
        self.premiumValue.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        self.premiumTitle.style(.medium, 14)
        self.premiumValue.style(.semibold, 14)
        
        
        
        
        
        let premiumString1: NSAttributedString = .init(string: "with_subscribe".localized(), attributes: [
            NSAttributedString.Key.font: UIFont.style(.medium, 14),
            NSAttributedString.Key.foregroundColor: UIColor.olchaTextBlack ?? .black])
        
        let premiumString2: NSAttributedString = .init(string: "Premium", attributes: [
            NSAttributedString.Key.font: UIFont.style(.medium, 14),
            NSAttributedString.Key.foregroundColor: UIColor.olchaAccentColor])
        
        let finalText = NSMutableAttributedString()
        finalText.append(premiumString1)
        finalText.append(premiumString2)
        
        self.premiumTitle.attributedText = finalText
    }
    
    private func configureWalletText() {
        
        self.olchaWalletTitle.numberOfLines = 0
        self.olchaWalletValue.numberOfLines = 0
        
        self.olchaWalletTitle.style(.medium, 14)
        self.olchaWalletValue.style(.semibold, 14)
        
        self.olchaWalletTitle.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        self.olchaWalletTitle.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        self.olchaWalletValue.setContentHuggingPriority(.init(1000), for: .horizontal)
        self.olchaWalletValue.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        
        
        
        let walletString1: NSAttributedString = .init(string: "on_payment".localized(), attributes: [
            NSAttributedString.Key.font: UIFont.style(.medium, 14),
            NSAttributedString.Key.foregroundColor: UIColor.olchaTextBlack ?? .black])
        
        let walletString2: NSAttributedString = .init(string: "witch_olcha_cash".localized(), attributes: [
            NSAttributedString.Key.font: UIFont.style(.medium, 14),
            NSAttributedString.Key.foregroundColor: UIColor.olchaAccentColor])
        
        
        
        
        let finalText = NSMutableAttributedString()
        finalText.append(walletString1)
        finalText.append(walletString2)
         
        
        self.olchaWalletTitle.attributedText = finalText
    }
    
    
    func setup(with data: String) {
        self.premiumValue.text = "234"
        self.olchaWalletValue.text = "541"
        self.ballTitle.text = "Получите до 448 балла"
    }
}
