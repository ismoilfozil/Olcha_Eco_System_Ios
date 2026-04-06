//
//  MyReviewRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/03/23.
//

import UIKit
import Combine
import OlchaUI
class MyReviewRoom: BaseTableCell {
    
    private let productImageView = UIImageView()
    private let productTitleLabel = UILabel()
//    let menuButton = IconButton()
    let productButton = Button()
    
    let commentSections = UIStackView()
    let questionView = FAQMainViewResponder()
    let reviewView = ReviewMainViewResponder()

    private let imageSize: CGFloat = 100
    
    var review: Comment?
    
    var product: ProductModel?
    
    weak var pushProduct: PassthroughSubject<ProductModel?, Never>?
    
    var type: ReviewType = .review
    
    override func setupViews() {
        container.addSubview(productImageView)
        container.addSubview(productTitleLabel)
        container.addSubview(commentSections)
        commentSections.addArrangedSubview(questionView)
        commentSections.addArrangedSubview(reviewView)
        
        container.addSubview(productButton)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 8
        
        productImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.width.height.equalTo(imageSize)
        }
        
//        menuButton.snp.makeConstraints { make in
//            make.right.top.equalToSuperview().inset(16)
//            make.width.height.equalTo(24)
//        }
        
        productTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp.right).inset(-8)
            make.top.equalTo(productImageView.snp.top)
            make.right.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(productImageView.snp.bottom)
        }
        
        commentSections.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        
        reviewView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        questionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        productButton.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp.left)
            make.right.equalTo(productTitleLabel.snp.right)
            make.top.equalTo(productImageView.snp.top)
            make.bottom.equalTo(productImageView.snp.bottom)
        }
    }
    
    override func configureViews() {
        container.round()
        container.border()
        
        productTitleLabel.style(.semibold, 16)
        productTitleLabel.numberOfLines = 0
        productTitleLabel.textColor = .olchaTextBlack
        
        reviewView.expandedReview = false
        reviewView.withShowAll = true
        reviewView.isHidden = true
        
        questionView.isHidden = true
        questionView.addFaqButton.isHidden = true
        
        
        productButton.clicked { [weak self] in
            guard let self = self else { return }
            self.pushProduct?.send(self.product)
        }
    }
    
    func setup(with data: Comment) {
        self.review = data
        self.product = data.product
        datasUpdated()
    }
    
    private func datasUpdated() {
        productImageView.load(from: product?.main_image, imageType: .equalSize(imageSize))
        productTitleLabel.text = product?.getName()
        
        reviewView.setup(with: review)
        
        questionView.setup(with: review)
        
        reviewView.isHidden = (type == .question)
        questionView.isHidden = (type == .review)
    }
}
