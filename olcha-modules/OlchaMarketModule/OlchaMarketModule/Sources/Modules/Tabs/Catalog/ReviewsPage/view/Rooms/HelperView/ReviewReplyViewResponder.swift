//
//  ProductReviewViewResponder.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/03/23.
//


import UIKit
import OlchaUI
import Combine
import Cosmos
import OlchaAuth
class ReviewReplyViewResponder: UIView {
    
    private let container = UIView()
    private let userIcon = UIImageView()
    
    private let userDataContainer = UIStackView()
    private let username = UILabel()
    private let replyNameLabel = UILabel()
    private let reviewDataContainer = UIStackView()
    private let reviewDate = UILabel()
    private let reviewRatingView = CosmosView()
    private let replySeparatorContainer = UIView()
    private let replySeparator = UIView()
    private let showAllReviews = Button()
    
    let bottomActionsContainer = UIStackView()

    private let likeSegment = LikeSegment()
    
    private let reviewText = UILabel()
    
    private let reviewMedia = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var images: [File] = []
    let manager = OtherLayoutManager()
    
    var review: Comment?
    
    var replyName: String = "" {
        didSet {
            replyNameLabel.text = replyName
        }
    }
    
    var expandedReview: Bool = true
    
    var withShowAll: Bool = false
    
    weak var pushReviewMedia: PassthroughSubject<(Comment, Int), Never>?
    weak var likeObserver: PassthroughSubject<(Comment?, LikeSegment.Value) , Never>?
    weak var pushReviewReplies: PassthroughSubject<Comment?, Never>?
    
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
        userDataContainer.addArrangedSubview(reviewDataContainer)
        reviewDataContainer.addArrangedSubview(reviewRatingView)
        reviewDataContainer.addArrangedSubview(reviewDate)
        
        
        container.addSubview(replySeparatorContainer)
        replySeparatorContainer.addSubview(replySeparator)
        
        container.addSubview(bottomActionsContainer)
        bottomActionsContainer.addArrangedSubview(likeSegment)
        bottomActionsContainer.addArrangedSubview(reviewMedia)
        bottomActionsContainer.addArrangedSubview(showAllReviews)
        
        container.addSubview(reviewText)
        
    }
    
    func autolayout() {
        container.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
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
        
        reviewRatingView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(6)
            make.width.equalTo(88)
            make.height.equalTo(16)
        }
        
        replySeparator.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(FAQReplyViewResponder.userIconWidth / 2)
            make.width.equalTo(1)
        }
        
        bottomActionsContainer.snp.makeConstraints { make in
            make.top.equalTo(reviewText.snp.bottom).inset(-12)
            make.left.equalTo(reviewText.snp.left)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        likeSegment.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(28)
        }
        
        reviewText.snp.remakeConstraints { make in
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
        
        reviewMedia.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        showAllReviews.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
    }
    
    func configureViews() {
        bottomActionsContainer.axis = .vertical
        bottomActionsContainer.alignment = .leading
        bottomActionsContainer.spacing = 4
        
        showAllReviews.setTitleColor(.olchaAccentColor, for: .normal)
        showAllReviews.titleLabel?.style(.regular, 12)
        
        showAllReviews.setTitle("", for: .normal)
        showAllReviews.isHidden = true
        
        reviewText.numberOfLines = 0
        reviewText.font = FAQReplyViewResponder.replyReviewFont
        userIcon.image = .profile_person
        
        userDataContainer.axis = .vertical
        userDataContainer.spacing = 4
        reviewDataContainer.axis = .horizontal
        reviewDataContainer.spacing = 16
        
        reviewRatingView.settings.updateOnTouch = false
        reviewRatingView.designCosmos(iconSize: 16)
        
        username.textColor = .olchaTextBlack
        username.style(.semibold, 14)
        
        reviewDate.textColor = .olchaLightTextColornnnnnn
        reviewDate.style(.medium, 12)
        
        replyNameLabel.style(.medium, 12)
        replyNameLabel.textColor = .olchaAccentColor
        
        replySeparator.backgroundColor = .lightGrayBackground1
        likeSegment.delegate = self
        
        
        reviewMedia.delegate = self
        reviewMedia.dataSource = self
        reviewMedia.registerClass(forCell: CorneredImage.self)
        reviewMedia.isScrollEnabled = false
        setupObservers()
        
    }
    
    
    private func setupObservers() {
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(collectionViewDidSelect(_:)))
        tapGR.numberOfTapsRequired = 1
        reviewMedia.addGestureRecognizer(tapGR)
        
        showAllReviews.clicked { [weak self] in
            guard let self = self else { return }
            self.pushReviewReplies?.send(self.review)
        }
    }

    @objc func collectionViewDidSelect(_ gr: UITapGestureRecognizer) {
        let point = gr.location(in: reviewMedia)
        if let indexPath = reviewMedia.indexPathForItem(at: point) {
            if let comment = review {
                pushReviewMedia?.send((comment, indexPath.item))
            }
        }
    }
    
    func setup(with data: Comment?) {
        review = data
        fillWithData()
        updateLayout()
    }
    
    private func fillWithData() {
        
        username.text = review?.user?.name
        reviewDate.text = review?.created_at
        reviewRatingView.rating = review?.rating ?? 5.0
        

        likeSegment.setup(with: review?.comment_rating)
        reviewText.text = review?.review ?? ""
        
        
        images = review?.files ?? []
        reviewMedia.reloadData()

        if (review?.child?.isEmpty ?? true) || !withShowAll {
            showAllReviews.isHidden = true
        } else {
            showAllReviews.isHidden = false
            showAllReviews.setTitle(
                .lang("Показать все ответы",
                      "Барча жавобларни кўрсатиш",
                      "Barcha javoblarni ko'rsatish"),
                for: .normal)
        }
    }
    
    
    private func updateLayout() {
        let isEmpty = review?.files?.isEmpty ?? true
        let rowsCount = expandedReview ? (images.count.float / 3).rounded(.up).int.cgfloat : 1
        
        reviewMedia.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()

            make.height.equalTo(reviewMedia.snp.width).multipliedBy((1/3) * rowsCount)
            
            make.width.equalTo(bottomActionsContainer.snp.width)
        }
        
        reviewMedia.collectionViewLayout = expandedReview ? manager.getLayout(with: .vGridCount(count: 3, heightOffset: 1)) : manager.getLayout(with: .grid(count: 3))
    }
    
    func configureHeaderReview() {
        //TO : DO
    }
}

extension ReviewReplyViewResponder: LikeSegmentDelegate {
    func selected(type: LikeSegment.Value) {
        self.likeObserver?.send((review, type))
    }
}


extension ReviewReplyViewResponder: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CorneredImage.self, for: indexPath)
        cell.setup(with: images[indexPath.item].full_path)
        return cell
    }
    
}
