//
//  FAQReplyViewResponder.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/03/23.
//


import UIKit
import Combine
import OlchaAuth
import Cosmos
class FAQReplyViewResponder: UIView {
    
    private let container = UIView()
    private let userIcon = UIImageView()
    
    //MARK: - THESE PROPERTIES FOR CALCULATE TEXT HEIGHT
    //-------******Change them when you change margins or width of views-------******//
    static let userIconWidth = 40
    static let userIconRightMargin = 12
    static let tableLeftRightMargin = 16
    static let mainReviewFont: UIFont = .style(.bold, 14)
    static let replyReviewFont: UIFont = .style(.regular, 14)
    
    //MARK: - THESE PROPERTIES FOR CALCULATE TEXT HEIGHT
    
    private let userDataContainer = UIStackView()
    private let username = UILabel()
    private let replyNameLabel = UILabel()
    private let faqDataContainer = UIStackView()
    private let faqDate = UILabel()
    private let replySeparatorContainer = UIView()
    private let replySeparator = UIView()
    
    let bottomActionsContainer = UIStackView()
    
    let likeSegmentContainer = UIStackView()
    private let likeSegment = LikeSegment()
    
    private let faqText = UILabel()
    
    
    let replyButton = Button()
    
    var faq: Comment?
    
    var replyName: String = "" {
        didSet {
            replyNameLabel.text = replyName
            
        }
    }

    weak var likeObserver: PassthroughSubject<(Comment?, LikeSegment.Value) , Never>?
    weak var pushFaqReplies: PassthroughSubject<Comment?, Never>?
    
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
        container.addSubview(userIcon)
        container.addSubview(userDataContainer)
        
        userDataContainer.addArrangedSubview(username)
        userDataContainer.addArrangedSubview(replyNameLabel)
        userDataContainer.addArrangedSubview(faqDataContainer)
        faqDataContainer.addArrangedSubview(faqDate)
        
        
        container.addSubview(replySeparatorContainer)
        replySeparatorContainer.addSubview(replySeparator)
        
        container.addSubview(bottomActionsContainer)
        bottomActionsContainer.addArrangedSubview(likeSegmentContainer)
        bottomActionsContainer.addArrangedSubview(replyButton)

        likeSegmentContainer.addArrangedSubview(likeSegment)
        
        container.addSubview(faqText)
        
    }
    
    func autolayout() {
        container.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(FAQReplyViewResponder.tableLeftRightMargin)
            make.bottom.equalToSuperview()
        }
        
        userIcon.snp.makeConstraints { make in
            make.width.height.equalTo(FAQReplyViewResponder.userIconWidth)
            make.left.top.equalToSuperview()
        }
        
        userDataContainer.snp.makeConstraints { make in
            make.left.equalTo(userIcon.snp.right).inset(-12)
            make.top.equalTo(userIcon.snp.top)
            make.right.equalToSuperview()
        }
        
        replySeparator.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(FAQReplyViewResponder.userIconWidth / 2)
            make.width.equalTo(1)
        }
        
        bottomActionsContainer.snp.makeConstraints { make in
            make.top.equalTo(faqText.snp.bottom).inset(-12)
            make.left.equalTo(faqText.snp.left)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        likeSegment.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(28)
        }
        
        faqText.snp.remakeConstraints { make in
            make.left.equalTo(replySeparatorContainer.snp.right)
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(userDataContainer.snp.bottom).inset(-12)
            make.top.greaterThanOrEqualTo(userIcon.snp.bottom).inset(-12)
        }
        
        replySeparatorContainer.snp.remakeConstraints { make in
            make.top.equalTo(userIcon.snp.bottom).inset(-8)
            make.left.equalTo(userIcon)
            make.width.equalTo(FAQReplyViewResponder.userIconWidth + FAQReplyViewResponder.userIconRightMargin)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func configureViews() {
        bottomActionsContainer.axis = .vertical
        bottomActionsContainer.alignment = .leading
        bottomActionsContainer.spacing = 4
        
        faqText.numberOfLines = 0
        userIcon.image = .profile_person
        
        userDataContainer.axis = .vertical
        userDataContainer.spacing = 4
        faqDataContainer.axis = .horizontal
        faqDataContainer.spacing = 16

        username.textColor = .olchaTextBlack
        username.style(.semibold, 14)
        
        faqDate.textColor = .olchaLightTextColornnnnnn
        faqDate.style(.medium, 12)
        
        replyNameLabel.style(.medium, 12)
        replyNameLabel.textColor = .olchaAccentColor
        
        replySeparator.backgroundColor = .lightGrayBackground1
        faqText.font = FAQReplyViewResponder.replyReviewFont
        
        replyButton.setTitleColor(.olchaAccentColor, for: .normal)
        
        let replyTitle = NSAttributedString(string: "reply".localized(),
                                            attributes: [
                                                .underlineStyle: NSUnderlineStyle.thick.rawValue,
                                                .underlineColor: UIColor.olchaAccentColor
                                            ])
        
        replyButton.titleLabel?.style(.regular, 14)
        replyButton.setAttributedTitle(replyTitle, for: .normal)
        replyButton.isHidden = false

        likeSegmentContainer.axis = .vertical
        likeSegmentContainer.spacing = 8

    }
    
    func setup(with data: Comment?) {
        faq = data
        fillWithData()
    }
    
    private func fillWithData() {
        
        username.text = faq?.user?.name
        faqDate.text = (faq?.created_at ?? "")
        
        likeSegment.setup(with: faq?.comment_rating)
        faqText.text = faq?.review ?? ""
    }
    
    func configureHeaderReview() {
        faqText.font = FAQReplyViewResponder.mainReviewFont
    }
}

extension FAQReplyViewResponder: LikeSegmentDelegate {
    func selected(type: LikeSegment.Value) {
        self.likeObserver?.send((faq, type))
    }
}
