//
//  AllReplyQuestionsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/03/23.
//
//import IHKeyboardAvoiding
import UIKit
import Combine
import OlchaUI
class AllQuestionRepliesPage: BaseViewController {

    private let bottomContainer = UIStackView()
    private let messageContainer = UIView()
    
    private let replyContainer = UIView()
    private let replyTitle = UILabel()
    private let replyValue = UILabel()
    private let cancelReply = IconButton()
    
    private let messageFieldContainer = UIView()
    private let messageField = PlaceholderTextView()
    private let sendIcon = IconButton()
    private let table = UITableView()
    
    private let messagContainerHeight: CGFloat = 60
    private let replyContinerHeight: CGFloat = 40
    
    let viewModel = ReviewsPageViewModel()
    private var bag = Set<AnyCancellable>()
    weak var coordinator: ReviewCoordinatorProtocol?
    //observers
    let likeObserver = PassthroughSubject<(Comment?, LikeSegment.Value), Never>()
    
    var product: ProductModel?
    
    var faq: Comment? {
        didSet {
            replies = faq?.child ?? []
        }
    }
    var replies: [Comment] = []
    
    var faqText = "" {
        didSet {
            animateButton()
        }
    }
    
    var repliedFAQ: Comment? {
        didSet {
            animateReply()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(table)
        container.addSubview(bottomContainer)
        
        bottomContainer.addArrangedSubview(replyContainer)
        bottomContainer.addArrangedSubview(messageContainer)
        
        messageContainer.addSubview(messageFieldContainer)
        messageFieldContainer.addSubview(messageField)
        messageContainer.addSubview(sendIcon)
        
        
        
        replyContainer.addSubview(replyTitle)
        replyContainer.addSubview(replyValue)
        replyContainer.addSubview(cancelReply)
    }
    
    override func autolayout() {
        super.autolayout()
        
        table.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        
        bottomContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        messageContainer.snp.makeConstraints { make in
            make.height.equalTo(messagContainerHeight)
        }
        
        messageFieldContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }
        
        messageField.snp.makeConstraints { make in
            make.right.bottom.top.equalToSuperview()
            make.left.equalToSuperview().inset(12)
        }
        
        sendIcon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(messageFieldContainer.snp.top)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(messageFieldContainer.snp.right).inset(-8)
        }
        
        replyContainer.snp.makeConstraints { make in
            make.height.equalTo(replyContinerHeight)
        }
        
        replyTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        replyValue.snp.makeConstraints { make in
            make.left.equalTo(replyTitle.snp.right).inset(-8)
            make.top.bottom.equalToSuperview()
            make.right.lessThanOrEqualTo(cancelReply.snp.left).inset(-16)
        }
        
        cancelReply.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        navigation.setTitle("questions".localized())
        
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = true
        table.separatorStyle = .none
        table.registerClass(forCell: ProductReplyFAQItem.self)
        table.registerClass(forCell: ProductMainFAQItem.self)
        table.estimatedRowHeight = UITableView.automaticDimension
        table.rowHeight = UITableView.automaticDimension
        table.contentInset = .init(top: 0, left: 0, bottom: messagContainerHeight + replyContinerHeight, right: 0)
        
        table.keyboardDismissMode = .onDrag
        
        bottomContainer.axis = .vertical
        bottomContainer.backgroundColor = .grayBackground
        view.backgroundColor = .grayBackground
        
        messageFieldContainer.round(16)
        messageFieldContainer.border(with: .grayBorder, width: 1)
        
        
        sendIcon.setIcon(.send, isIgnoringEdge: false)
        
        messageField.placeholder = "reply_placeholder".localized()
        messageField.font = .style(.regular, 14)
        
        messageField.textColor = .olchaLightTextColornnnnnn
        
        messageField.backgroundColor = .clear
        messageFieldContainer.backgroundColor = .clear
        
        sendIcon.round(16)
        sendIcon.backgroundColor = .grayBorder
        
        replyContainer.isHidden = true
        replyTitle.textColor = .olchaLightTextColornnnnnn
        replyTitle.style(.regular, 14)
        replyTitle.text = "answer".localized()
        
        replyValue.textColor = .olchaLightTextColornnnnnn
        replyValue.style(.semibold, 14)
        
        cancelReply.setIcon(.x_cancel)
        replyContainer.backgroundColor = .olchaLightNeutralGray
        #warning("T##message")
//        KeyboardAvoiding.avoidingView = bottomContainer
        
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        messageField.observeText { [weak self] _ in
            guard let self = self else { return }
            self.animateButton()
            
        }
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        cancelReply.clicked { [weak self] in
            guard let self = self else { return }
            self.repliedFAQ = nil
        }
        
        likeObserver.sink { [weak self] val in
            guard let self = self else { return }
            coordinator?.pushAuth {
                if let reviewID = val.0?.id {
                    if val.1 == .liked {
                        self.viewModel.likeComment(with: reviewID)
                    }
                    
                    if val.1 == .disliked {
                        self.viewModel.dislikeComment(with: reviewID)
                    }
                }
            }
        }.store(in: &bag)
        
        
        sendIcon.clicked { [weak self] in
            guard let self = self else { return }
            self.messageField.resignFirstResponder()
            
            guard let productID = self.product?.id else { return }
            guard let replyID = self.repliedFAQ?.id ?? self.faq?.id else { return }
            
            if self.messageField.currentText.withoutWhiteSpace != "" {
                let faqText = self.messageField.currentText
                
                self.viewModel.send(question: faqText,
                                    productID: productID,
                                    repliedID: replyID)
                
            }
        }
        
        viewModel.$questionSuccess.sink { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                self.coordinator?.pushReviewFinish(type: .question,
                                                   lastPage: Self.self)
                self.messageField.text = ""
            }
        }.store(in: &bag)
        
    }
    

    
    override func initialRequest() {
        super.initialRequest()
    }
    
    private func animateButton() {
        if messageField.currentText.withoutWhiteSpace == "" {
            sendIcon.backgroundColor = .grayBorder
        } else {
            sendIcon.backgroundColor = .olchaBlue
        }
    }
    
    private func animateReply() {
        if let review = repliedFAQ {
            replyValue.text = review.user?.name
            replyContainer.isHidden = false
        } else {
            replyContainer.isHidden = true
        }
    }

    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        messageField.resignFirstResponder()

    }
}
