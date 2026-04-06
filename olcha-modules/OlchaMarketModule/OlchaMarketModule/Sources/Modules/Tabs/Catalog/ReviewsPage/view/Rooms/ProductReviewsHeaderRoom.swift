//
//  ProductReviewsHeaderRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/08/22.
//

import UIKit
import Cosmos
import OlchaUI
import Combine
class ProductReviewsHeaderRoom: BaseTableCell {
    private let containerStack = UIStackView()
    //review info section
    private let ratingContainer = UIView()
    private let reviewsTitle = UILabel()
    private let reviewsValue = UILabel()
    private let ratingView = CosmosView()
    private let ratingValue = UILabel()
    
    private let reviewButtonContainer = UIView()
    private let ratingContainerSeparator = Divide()
    let writeReviewButton = Button()
    let infoIcon = IconButton()
    //media section
    private let mediaContainer = UIView()
    private let mediaTitle = UILabel()
    private let mediaCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    weak var pushReviewMedia: PassthroughSubject<(Comment, Int), Never>?
    weak var pushAllMedia: PassthroughSubject<Int, Never>?
    private var bag = Set<AnyCancellable>()
    
    
    var reviewsData: ReviewsData?
    var product: ProductModel?
    var reviewFiles: ReviewFilesData?
    
    override func setupViews() {
        container.addSubview(containerStack)
        
        containerStack.addArrangedSubview(ratingContainer)
        containerStack.addArrangedSubview(reviewButtonContainer)
        containerStack.addArrangedSubview(mediaContainer)
        
        ratingContainer.addSubview(reviewsTitle)
        ratingContainer.addSubview(reviewsValue)
        ratingContainer.addSubview(ratingView)
        ratingContainer.addSubview(ratingValue)
        ratingContainer.addSubview(infoIcon)
        
        reviewButtonContainer.addSubview(ratingContainerSeparator)
        reviewButtonContainer.addSubview(writeReviewButton)
        
        mediaContainer.addSubview(mediaTitle)
        mediaContainer.addSubview(mediaCollection)
        
    }
    
    override func autolayout() {
        containerStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        
        reviewInfoSectionAutolayout()
        mediaSectionAutolayout()
        
    }
    
    override func configureViews() {
        containerStack.axis = .vertical
        containerStack.spacing = 16
        reviewInfoSectionConfiguration()
        mediaSectionConfiguration()
        
    }
    
    private func reviewInfoSectionAutolayout() {
        
        
        reviewButtonContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        ratingContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        ratingContainerSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        writeReviewButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(ratingContainerSeparator.snp.bottom).inset(-16)
            make.width.equalTo(155)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        reviewsTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        reviewsValue.snp.makeConstraints { make in
            make.left.equalTo(reviewsTitle.snp.right).inset(-8)
            make.centerY.equalTo(reviewsTitle.snp.centerY)
            make.right.lessThanOrEqualToSuperview().inset(8)
        }
        
        ratingView.snp.makeConstraints { make in
            make.top.equalTo(reviewsTitle.snp.bottom).inset(-16)
            make.left.equalToSuperview().inset(6)
            make.height.equalTo(24)
            make.width.equalTo(120)
            make.bottom.equalToSuperview().inset(8)
        }
        
        
        ratingValue.snp.makeConstraints { make in
            make.left.equalTo(ratingView.snp.right).inset(-16)
            make.centerY.equalTo(ratingView.snp.centerY)
        }
        
        infoIcon.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerY.equalTo(ratingView.snp.centerY)
        }
        
    }
    
    private func reviewInfoSectionConfiguration() {
        
        self.reviewsTitle.style(.semibold, 24)
        self.reviewsTitle.textColor = .olchaTextBlack
        self.reviewsTitle.text = "reviews".localized()
        
        self.reviewsValue.style(.semibold, 18)
        self.reviewsValue.textColor = .olchaLightTextColornnnnnn
        self.reviewsValue.text = "0"
        
        self.ratingView.designCosmos(iconSize: 24 )
        self.ratingView.settings.updateOnTouch = false
        self.ratingValue.style(.semibold, 18)
        self.ratingValue.textColor = .olchaTextBlack
        
        self.infoIcon.setIcon(.info?.withTintColor(.olchaTextBlack ?? .black, renderingMode: .alwaysOriginal))
        
        self.writeReviewButton.round()
        self.writeReviewButton.backgroundColor = .olchaAccentColor
        self.writeReviewButton.setTitle("add_review".localized(), for: .normal)
        self.writeReviewButton.titleLabel?.style(.medium, 16)
        self.writeReviewButton.setTitleColor(.olchaWhite, for: .normal)
        
        reviewButtonContainer.isHidden = true
    }
    
    
    private func mediaSectionAutolayout() {
        
        mediaContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        mediaTitle.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        mediaCollection.snp.makeConstraints { make in
            make.top.equalTo(self.mediaTitle.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(-4)
            make.bottom.equalToSuperview()
            make.height.equalTo(self.mediaCollection.snp.width).multipliedBy(0.25)
            make.bottom.equalToSuperview()
        }
    }
    
    private func mediaSectionConfiguration() {
        self.mediaTitle.style(.semibold, 18)
        self.mediaTitle.textColor = .olchaTextBlack
        self.mediaTitle.text = "customers_pictures".localized()
        self.mediaCollection.delegate = self
        self.mediaCollection.dataSource = self
        self.mediaCollection.registerClass(forCell: CorneredImage.self)
        mediaCollection.backgroundColor = .olchaBackgroundColor
        
        let manager = OtherLayoutManager()
        self.mediaCollection.collectionViewLayout = manager.getLayout(with: .grid(count: 4))
    }
    
    func setup(with data: ReviewsData?, product: ProductModel?, reviewFiles: ReviewFilesData?) {
        self.product = product
        self.reviewsData = data
        self.reviewFiles = reviewFiles
        
        self.fillWithData()
    }
    
    private func fillWithData() {
        self.reviewsValue.text = self.reviewsData?.paginator?.total?.string
        self.ratingValue.text = (product?.rating ?? 0).string + " / 5"
        
        if (reviewFiles?.files?.isEmpty ?? true) {
            self.mediaContainer.isHidden = true
        } else {
            self.mediaContainer.isHidden = false
            self.mediaCollection.reloadData()
        }
        
        self.ratingView.rating = (reviewsData?.total_comments?.rating ?? 0.0).int.double
        
        reviewButtonContainer.isHidden = !(product?.can_comment ?? false)
    }

}
class ProductReviewsHeaderRoomView: BaseTableCellView {
    private let containerStack = UIStackView()
    //review info section
    private let ratingContainer = UIView()
    private let reviewsTitle = UILabel()
    private let reviewsValue = UILabel()
    private let ratingView = CosmosView()
    private let ratingValue = UILabel()
    
    private let reviewButtonContainer = UIView()
    private let ratingContainerSeparator = Divide()
    let writeReviewButton = Button()
    let infoIcon = IconButton()
    //media section
    private let mediaContainer = UIView()
    private let mediaTitle = UILabel()
    private let mediaCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    weak var pushReviewMedia: PassthroughSubject<(Comment, Int), Never>?
    weak var pushAllMedia: PassthroughSubject<Int, Never>?
    private var bag = Set<AnyCancellable>()
    
    
    var reviewsData: ReviewsData?
    var product: ProductModel?
    var reviewFiles: ReviewFilesData?
    
    override func setupViews() {
        container.addSubview(containerStack)
        
        containerStack.addArrangedSubview(ratingContainer)
        containerStack.addArrangedSubview(reviewButtonContainer)
        containerStack.addArrangedSubview(mediaContainer)
        
        ratingContainer.addSubview(reviewsTitle)
        ratingContainer.addSubview(reviewsValue)
        ratingContainer.addSubview(ratingView)
        ratingContainer.addSubview(ratingValue)
        ratingContainer.addSubview(infoIcon)
        
        reviewButtonContainer.addSubview(ratingContainerSeparator)
        reviewButtonContainer.addSubview(writeReviewButton)
        
        mediaContainer.addSubview(mediaTitle)
        mediaContainer.addSubview(mediaCollection)
        
    }
    
    override func autolayout() {
        containerStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        
        reviewInfoSectionAutolayout()
        mediaSectionAutolayout()
        
    }
    
    override func configureViews() {
        containerStack.axis = .vertical
        containerStack.spacing = 16
        reviewInfoSectionConfiguration()
        mediaSectionConfiguration()
        
    }
    
    private func reviewInfoSectionAutolayout() {
        
        
        reviewButtonContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        ratingContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        ratingContainerSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        writeReviewButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(ratingContainerSeparator.snp.bottom).inset(-16)
            make.width.equalTo(155)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        reviewsTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        reviewsValue.snp.makeConstraints { make in
            make.left.equalTo(reviewsTitle.snp.right).inset(-8)
            make.centerY.equalTo(reviewsTitle.snp.centerY)
            make.right.lessThanOrEqualToSuperview().inset(8)
        }
        
        ratingView.snp.makeConstraints { make in
            make.top.equalTo(reviewsTitle.snp.bottom).inset(-16)
            make.left.equalToSuperview().inset(6)
            make.height.equalTo(24)
            make.width.equalTo(120)
            make.bottom.equalToSuperview().inset(8)
        }
        
        
        ratingValue.snp.makeConstraints { make in
            make.left.equalTo(ratingView.snp.right).inset(-16)
            make.centerY.equalTo(ratingView.snp.centerY)
        }
        
        infoIcon.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerY.equalTo(ratingView.snp.centerY)
        }
        
    }
    
    private func reviewInfoSectionConfiguration() {
        
        self.reviewsTitle.style(.semibold, 24)
        self.reviewsTitle.textColor = .olchaTextBlack
        self.reviewsTitle.text = "reviews".localized()
        
        self.reviewsValue.style(.semibold, 18)
        self.reviewsValue.textColor = .olchaLightTextColornnnnnn
        self.reviewsValue.text = "0"
        
        self.ratingView.designCosmos(iconSize: 24 )
        self.ratingView.settings.updateOnTouch = false
        self.ratingValue.style(.semibold, 18)
        self.ratingValue.textColor = .olchaTextBlack
        
        self.infoIcon.setIcon(.info?.withTintColor(.olchaTextBlack ?? .black, renderingMode: .alwaysOriginal))
        
        self.writeReviewButton.round()
        self.writeReviewButton.backgroundColor = .olchaAccentColor
        self.writeReviewButton.setTitle("add_review".localized(), for: .normal)
        self.writeReviewButton.titleLabel?.style(.medium, 16)
        self.writeReviewButton.setTitleColor(.olchaWhite, for: .normal)
        
        reviewButtonContainer.isHidden = true
    }
    
    
    private func mediaSectionAutolayout() {
        
        mediaContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        mediaTitle.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        mediaCollection.snp.makeConstraints { make in
            make.top.equalTo(self.mediaTitle.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(-4)
            make.bottom.equalToSuperview()
            make.height.equalTo(self.mediaCollection.snp.width).multipliedBy(0.25)
            make.bottom.equalToSuperview()
        }
    }
    
    private func mediaSectionConfiguration() {
        self.mediaTitle.style(.semibold, 18)
        self.mediaTitle.textColor = .olchaTextBlack
        self.mediaTitle.text = "customers_pictures".localized()
        self.mediaCollection.delegate = self
        self.mediaCollection.dataSource = self
        self.mediaCollection.registerClass(forCell: CorneredImage.self)
        mediaCollection.backgroundColor = .olchaBackgroundColor
        
        let manager = OtherLayoutManager()
        self.mediaCollection.collectionViewLayout = manager.getLayout(with: .grid(count: 4))
    }
    
    func setup(with data: ReviewsData?, product: ProductModel?, reviewFiles: ReviewFilesData?) {
        self.product = product
        self.reviewsData = data
        self.reviewFiles = reviewFiles
        
        self.fillWithData()
    }
    
    private func fillWithData() {
        self.reviewsValue.text = self.reviewsData?.paginator?.total?.string
        self.ratingValue.text = (product?.rating ?? 0).string + " / 5"
        
        if (reviewFiles?.files?.isEmpty ?? true) {
            self.mediaContainer.isHidden = true
        } else {
            self.mediaContainer.isHidden = false
            self.mediaCollection.reloadData()
        }
        
        self.ratingView.rating = (reviewsData?.total_comments?.rating ?? 0.0).int.double
        
        reviewButtonContainer.isHidden = !(product?.can_comment ?? false)
    }

}
