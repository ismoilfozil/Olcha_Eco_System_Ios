//
//  ProductReviewResponder.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/03/23.
//


import UIKit
import Combine
import OlchaUI
import Cosmos
import OlchaAuth
class ReviewMainViewResponder: UIView {
    
    private let container = UIStackView()
    private let userIcon = UIImageView()
    
    private let userDataContainer = UIView()
    private let username = UILabel()
    private let reviewDataContainer = UIStackView()
    private let reviewDate = UILabel()
    private let reviewRatingView = CosmosView()
    let showAllReviews = Button()
    
    private let likeSegment = LikeSegment()
    
    private let reviewText = UILabel()
    
    private let reviewMedia = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var images: [File] = []
    let manager = OtherLayoutManager()
    
    var review: Comment?
    
    weak var pushReviewMedia: PassthroughSubject<(Comment, Int), Never>?
    weak var likeObserver: PassthroughSubject<(Comment?, LikeSegment.Value) , Never>?
    weak var pushReviewReplies: PassthroughSubject<Comment?, Never>?
    
    var expandedReview: Bool = true
    
    var withShowAll: Bool = false
    
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
        
        container.addArrangedSubview(userDataContainer)
        
        userDataContainer.addSubview(username)
        userDataContainer.addSubview(userIcon)
        userDataContainer.addSubview(reviewDataContainer)
        
        
        reviewDataContainer.addArrangedSubview(reviewRatingView)
        reviewDataContainer.addArrangedSubview(reviewDate)
        
        
        container.addArrangedSubview(likeSegment)
        
        container.addArrangedSubview(reviewText)
        
        container.addArrangedSubview(reviewMedia)
        container.addArrangedSubview(showAllReviews)
    }
    
    func autolayout() {
        container.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        userDataContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        userIcon.snp.makeConstraints { make in
            make.width.height.equalTo(FAQReplyViewResponder.userIconWidth)
            make.left.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        username.snp.makeConstraints { make in
            make.left.equalTo(userIcon.snp.right).inset(-12)
            make.top.equalTo(userIcon.snp.top)
            make.right.equalToSuperview().inset(8)
        }
        
        reviewDataContainer.snp.makeConstraints { make in
            make.left.equalTo(username.snp.left)
            make.right.lessThanOrEqualToSuperview()
            make.top.equalTo(username.snp.bottom).inset(-4)
            make.bottom.equalToSuperview()
        }
        
        likeSegment.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(28)
        }
        
        reviewText.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        reviewMedia.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        showAllReviews.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
    }
    
    func configureViews() {
        container.alignment = .leading
        container.axis = .vertical
        container.spacing = 12
        
        showAllReviews.setTitleColor(.olchaAccentColor, for: .normal)
        showAllReviews.titleLabel?.style(.regular, 12)
        
        showAllReviews.setTitle("", for: .normal)
        showAllReviews.isHidden = true
        
        reviewText.numberOfLines = 0
        reviewText.font = FAQReplyViewResponder.replyReviewFont
        userIcon.image = .profile_person
        
        
        reviewDataContainer.axis = .horizontal
        reviewDataContainer.spacing = 16
        
        reviewRatingView.settings.updateOnTouch = false
        reviewRatingView.designCosmos(iconSize: 16)
        
        username.textColor = .olchaTextBlack
        username.style(.semibold, 14)
        
        reviewDate.textColor = .olchaLightTextColornnnnnn
        reviewDate.style(.medium, 12)
        
        
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
    
    func configureHeaderReview() {
        reviewText.font = FAQReplyViewResponder.mainReviewFont
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
                .lang("Показать все комментарии",
                      "Барча изоҳларни кўрсатиш",
                      "Barcha izohlarni ko'rsatish"),
                for: .normal)
        }
    }
    
    
    private func updateLayout() {
        let isEmpty = review?.files?.isEmpty ?? true
        
        let rowsCount = expandedReview ? (images.count.float / 3).rounded(.up).int.cgfloat : 1
        
        reviewMedia.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(reviewMedia.snp.width).multipliedBy((1/3) * rowsCount)
            
            make.width.equalTo(container.snp.width)
        }
        
        reviewMedia.collectionViewLayout = expandedReview ? manager.getLayout(with: .vGridCount(count: 3, heightOffset: 1)) : manager.getLayout(with: .grid(count: 3))
        reviewMedia.isHidden = isEmpty
    }
    
}

extension ReviewMainViewResponder: LikeSegmentDelegate {
    func selected(type: LikeSegment.Value) {
        self.likeObserver?.send((review, type))
    }
}


extension ReviewMainViewResponder: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CorneredImage.self, for: indexPath)
        cell.setup(with: images[indexPath.item].full_path)
        return cell
    }
    
}
