//
//  FAQMainViewResponder.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/03/23.
//

import Foundation
import UIKit
import Combine
import OlchaAuth
import OlchaUI
import Cosmos
class FAQMainViewResponder: UIView {
    private let container = UIStackView()
    private let userContainer = UIView()
    private let userImage = UIImageView()
    private let username = UILabel()
    private let faqDate = UILabel()
    
    private let faqText = UILabel()
    
    let likeSegment = LikeSegment()
    private let showAllFaqs = Button()
    
    let actionsContainer = UIView()
    let addFaqButton = Button()
    
    
    var comment: Comment?
    
    weak var pushFaqReplies: PassthroughSubject<Comment?, Never>?
    
    weak var likeObserver: PassthroughSubject<(Comment?, LikeSegment.Value), Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        autolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(container)
        container.addArrangedSubview(userContainer)
        container.addArrangedSubview(faqText)
        
        container.addArrangedSubview(actionsContainer)
        container.addArrangedSubview(showAllFaqs)
        
        userContainer.addSubview(userImage)
        userContainer.addSubview(username)
        userContainer.addSubview(faqDate)
        
        actionsContainer.addSubview(addFaqButton)
        actionsContainer.addSubview(likeSegment)
        
    }
    
    ///change this function also when update layout
    ///static func calculateCommentCell(textWidth: CGFloat, text: String, isMediaEmpty: Bool)
    func autolayout() {
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        userContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        userImage.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.bottom.top.left.equalToSuperview()
        }
        
        username.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalTo(userImage.snp.right).inset(-12)
        }
        
        faqDate.snp.makeConstraints { make in
            make.left.equalTo(username.snp.left)
            make.right.equalToSuperview()
            make.top.equalTo(username.snp.bottom).inset(-4)
            make.bottom.equalToSuperview()
        }
        
        faqText.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        actionsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        addFaqButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(140)
        }
        
        likeSegment.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.height.equalTo(28)
            make.centerY.equalTo(addFaqButton.snp.centerY)
        }
        
        showAllFaqs.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
    }
    
    func configureViews() {
        container.axis = .vertical
        container.spacing = 8
        container.distribution = .fill
        container.alignment = .leading
        
        userImage.round(20)
        userImage.contentMode = .scaleAspectFit
        userImage.image = .user
        
        username.style(.semibold, 14)
        username.textColor = .olchaTextBlack
        
        
        
        faqDate.style(.medium, 12)
        faqDate.textColor = .olchaLightTextColornnnnnn
        
        faqText.numberOfLines = 0
        faqText.style(.regular, 14)
        faqText.textColor = .olchaTextBlack
        
        showAllFaqs.setTitleColor(.olchaAccentColor, for: .normal)
        showAllFaqs.titleLabel?.style(.regular, 12)
        
        showAllFaqs.setTitle("", for: .normal)
        showAllFaqs.isHidden = true
        
        addFaqButton.backgroundColor = .olchaAccentColor
        addFaqButton.round(8)
        addFaqButton.setTitleColor(.olchaWhite, for: .normal)
        addFaqButton.setTitle("reply".localized(), for: .normal)
        addFaqButton.titleLabel?.style(.medium, 14)
        
       
        faqText.text = ""
        
        setupObservers()
    }
    

    func setupObservers() {
        likeSegment.delegate = self
        showAllFaqs.clicked { [weak self] in
            guard let self = self else { return }
            self.pushFaqReplies?.send(self.comment)
        }
        
        addFaqButton.clicked { [weak self] in
            guard let self = self else { return }
            self.pushFaqReplies?.send(self.comment)
        }
    }
    
    func setup(with data: Comment?) {
        self.comment = data
        self.fillWithData()
    }
    
    private func fillWithData() {
        let name = (self.comment?.user?.name ?? "")
        let lastname = (self.comment?.user?.lastname ?? "")
        let fullname = name + " " + lastname
        
        
        username.text =  fullname
        faqDate.text = self.comment?.created_at
        
        faqText.text = (self.comment?.review ?? "")
        faqText.sizeToFit()
        likeSegment.setup(with: comment?.comment_rating)
        
        if (comment?.child?.isEmpty ?? true) {
            showAllFaqs.isHidden = true
        } else {
            showAllFaqs.isHidden = false
            showAllFaqs.setTitle(.lang("Показать все ответы",
                                       "Барча жавобларни кўрсатиш",
                                       "Barcha javoblarni ko'rsatish"),
                                 for: .normal)
        }
    }
    
    func configureHeader() {
        addFaqButton.isHidden = true
        showAllFaqs.isHidden = true
    }
    
}
extension FAQMainViewResponder: LikeSegmentDelegate {
    func selected(type: LikeSegment.Value) {
        likeObserver?.send((comment, type))
    }
}


