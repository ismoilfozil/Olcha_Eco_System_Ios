//
//  EmptyBonusModalPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 13/02/24.
//

import UIKit
import OlchaUI

class EmptyBonusModalPage: BaseModalViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .olchaWhite
        label.style(.bold, 38)
        label.text = "for_you_cashback".localized()
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .empty_cashback
        return imageView
    }()
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.round(16, topCorner: true, bottomCorner: false)
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let contentFooter: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    
    override func setupViews() {
        container.addSubview(imageView)
        container.addSubview(titleLabel)
        container.addSubview(contentContainer)
        contentContainer.addSubview(contentStackView)
        contentStackView.addArrangedSubview(contentLabel)
        contentStackView.addArrangedSubview(contentFooter)
    }
    
    override func autolayout() {
        imageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(140)
            make.bottom.equalTo(contentContainer.snp.top).inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.right.equalTo(imageView.snp.left).inset(24)
        }
        
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-24)
            make.bottom.left.right.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        contentFooter.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    override func configureViews() {
        let content: String = .lang(
            "Сделано в эко системе вишни ваши покупки, ваши комментарии, Вишня Каждый сделан через платежную систему Pay ваши переводы также являются партнерскими за ваши покупки в нашей сети магазинов имеет гарантированный кэшбэк и бонусы вы будете\n\nЧтобы сделать каждую вашу покупку еще выгоднее не забывайте использовать бонусную систему.",
            "Олча эко тизимида амалга оширган харидларингиз, қолдирган шарҳларингиз, Олча Пай тўлов тизими орқали амалга оширган ҳар бир ўтказмаларингиз шунингдек ҳамкор дўконларимиз тармоғидаги харидларингиз учун кафолатланган Cашбаcк ва бонусларга эга бўласиз.\n\nҲар бир харидингизни фойдалироқ қилиш учун бонус тизимидан фойдаланишни унутманг.",
            "Olcha eko tizimida amalga oshirgan xaridlaringiz, qoldirgan sharhlaringiz, Olcha Pay to‘lov tizimi orqali amalga oshirgan har bir o‘tkazmalaringiz shuningdek hamkor do‘konlarimiz tarmog‘idagi xaridlaringiz uchun kafolatlangan Cashback va bonuslarga ega bo‘lasiz.\n\nHar bir xaridingizni foydaliroq qilish uchun bonus tizimidan foydalanishni unutmang.")
        
        contentLabel.text = content
        
        let footer: String = .lang(
            "Счастливые покупки!",
            "Хайрли харид тилаймиз!",
            "Xayrli xarid tilaymiz!")
        
        contentFooter.text = footer
        fullBackgroundColor = .olchaPrimaryColor
        bottomEdgeColor = .olchaWhite
    }
    
}
