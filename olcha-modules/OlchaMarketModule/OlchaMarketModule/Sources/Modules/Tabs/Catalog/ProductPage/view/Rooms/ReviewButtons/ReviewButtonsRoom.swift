//
//  ReviewButtonsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/07/22.
//

import UIKit
import Cosmos
import Combine
import OlchaUI
class ReviewButtonsRoom: BaseTableCell {
    
    private let scrollView = UIScrollView()
    private let buttonsContainer = UIStackView()
    
    //MARK: - Review/Rating button
    private let ratingContainer = UIView()
    private let ratingView = CosmosView()
    private let ratingTitle = UILabel()
    
    //MARK: - Video button
    private let videoContainer = UIView()
    private let videoIcon = UIImageView()
    private let videoValue = UILabel()
    private let videoTitle = UILabel()
    
    //MARK: - Questions button
    private let questionsContainer = UIView()
    private let questionsIcon = UIImageView()
    private let questionsValue = UILabel()
    private let questionsTitle = UILabel()
    
    let ratingButton = Button()
    let videoButton = Button()
    let questionsButton = Button()
    
    weak var reviewButtonClicker: PassthroughSubject<ProductPage.ButtonsType, Never>?
    
    override func setupViews() {
        container.addSubview(scrollView)
        self.scrollView.addSubview(buttonsContainer)
        self.buttonsContainer.addArrangedSubview(self.ratingContainer)
        self.buttonsContainer.addArrangedSubview(self.videoContainer)
        self.buttonsContainer.addArrangedSubview(self.questionsContainer)
        
        self.ratingContainer.addSubview(ratingView)
        self.ratingContainer.addSubview(ratingTitle)
        self.ratingContainer.addSubview(ratingButton)

        self.videoContainer.addSubview(videoIcon)
        self.videoContainer.addSubview(videoValue)
        self.videoContainer.addSubview(videoTitle)
        self.videoContainer.addSubview(videoButton)
        
        self.questionsContainer.addSubview(questionsIcon)
        self.questionsContainer.addSubview(questionsValue)
        self.questionsContainer.addSubview(questionsTitle)
        self.questionsContainer.addSubview(questionsButton)
    }
    
    override func autolayout() {
        self.scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.buttonsContainer.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(self.scrollView.snp.height)
        }
        
        self.ratingContainer.snp.makeConstraints { make in
            make.width.equalTo(132)
        }
        
        self.videoContainer.snp.makeConstraints { make in
            make.width.equalTo(107)
        }
        
        self.questionsContainer.snp.makeConstraints { make in
            make.width.equalTo(107)
        }
        
        self.ratingView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(12)
            make.height.equalTo(20)
        }
        
        self.ratingTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        self.videoIcon.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(12)
            make.width.height.equalTo(20)
        }
        
        self.videoValue.snp.makeConstraints { make in
            make.centerY.equalTo(self.videoIcon.snp.centerY)
            make.right.equalToSuperview().inset(12)
            make.left.equalTo(self.videoIcon.snp.right).inset(-8)
        }
        
        self.videoTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        self.questionsIcon.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.top.left.equalToSuperview().inset(12)
        }
        
        self.questionsValue.snp.makeConstraints { make in
            make.centerY.equalTo(self.questionsIcon.snp.centerY)
            make.right.equalToSuperview().inset(12)
            make.left.equalTo(self.questionsIcon.snp.right).inset(-8)
        }
        
        self.questionsTitle.snp.makeConstraints { make in
            make.bottom.right.left.equalToSuperview().inset(12)
        }
        
        self.ratingButton.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.videoButton.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.questionsButton.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        self.buttonsContainer.axis = .horizontal
        self.buttonsContainer.spacing = 8
        
        self.ratingContainer.round()
        self.ratingContainer.backgroundColor = .lightGrayBackground
        self.videoContainer.round()
        self.videoContainer.backgroundColor = .lightGrayBackground
        self.questionsContainer.round()
        self.questionsContainer.backgroundColor = .lightGrayBackground
        
        self.ratingTitle.style(.medium, 12)
        self.ratingTitle.textColor = .olchaBlue
        
        self.videoTitle.style(.medium, 12)
        self.videoTitle.textColor = .olchaBlue
        
        self.questionsTitle.style(.medium, 12)
        self.questionsTitle.textColor = .olchaBlue
        
        self.videoValue.style(.medium, 12)
        self.questionsValue.style(.medium, 12)
        
        self.videoIcon.image = .video
        self.questionsIcon.image = .question
        
        self.videoTitle.text = "video_reviews".localized()
        self.questionsTitle.text = "question_reviews".localized()
        
        self.ratingView.designCosmos(iconSize: 20)
        
        self.ratingButton.clicked { [weak self] in
            guard let self = self else { return }
            self.reviewButtonClicker?.send(.rating)
        }
        
        videoContainer.isHidden = true
    }
    
    
    func setup(with data: ProductModel?, reviews: ReviewsData?) {
        self.ratingView.rating = Double(data?.rating ?? 0)
        self.ratingTitle.text = (reviews?.paginator?.total ?? 0).string + " " + "reviews".localized()
        self.videoValue.text = "0"
        self.questionsValue.text = "0"   
    }
    
}

class ReviewButtonsRoomView: BaseTableCellView {
    
    private let scrollView = UIScrollView()
    private let buttonsContainer = UIStackView()
    
    //MARK: - Review/Rating button
    private let ratingContainer = UIView()
    private let ratingView = CosmosView()
    private let ratingTitle = UILabel()
    
    //MARK: - Video button
    private let videoContainer = UIView()
    private let videoIcon = UIImageView()
    private let videoValue = UILabel()
    private let videoTitle = UILabel()
    
    //MARK: - Questions button
    private let questionsContainer = UIView()
    private let questionsIcon = UIImageView()
    private let questionsValue = UILabel()
    private let questionsTitle = UILabel()
    
    let ratingButton = Button()
    let videoButton = Button()
    let questionsButton = Button()
    
    weak var reviewButtonClicker: PassthroughSubject<ProductPage.ButtonsType, Never>?
    
    override func setupViews() {
        container.addSubview(scrollView)
        self.scrollView.addSubview(buttonsContainer)
        self.buttonsContainer.addArrangedSubview(self.ratingContainer)
        self.buttonsContainer.addArrangedSubview(self.videoContainer)
        self.buttonsContainer.addArrangedSubview(self.questionsContainer)
        
        self.ratingContainer.addSubview(ratingView)
        self.ratingContainer.addSubview(ratingTitle)
        self.ratingContainer.addSubview(ratingButton)

        self.videoContainer.addSubview(videoIcon)
        self.videoContainer.addSubview(videoValue)
        self.videoContainer.addSubview(videoTitle)
        self.videoContainer.addSubview(videoButton)
        
        self.questionsContainer.addSubview(questionsIcon)
        self.questionsContainer.addSubview(questionsValue)
        self.questionsContainer.addSubview(questionsTitle)
        self.questionsContainer.addSubview(questionsButton)
    }
    
    override func autolayout() {
        container.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(64)
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.buttonsContainer.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(self.scrollView.snp.height)
        }
        
        self.ratingContainer.snp.makeConstraints { make in
            make.width.equalTo(132)
        }
        
        self.videoContainer.snp.makeConstraints { make in
            make.width.equalTo(107)
        }
        
        self.questionsContainer.snp.makeConstraints { make in
            make.width.equalTo(107)
        }
        
        self.ratingView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(12)
            make.height.equalTo(20)
        }
        
        self.ratingTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        self.videoIcon.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(12)
            make.width.height.equalTo(20)
        }
        
        self.videoValue.snp.makeConstraints { make in
            make.centerY.equalTo(self.videoIcon.snp.centerY)
            make.right.equalToSuperview().inset(12)
            make.left.equalTo(self.videoIcon.snp.right).inset(-8)
        }
        
        self.videoTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        self.questionsIcon.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.top.left.equalToSuperview().inset(12)
        }
        
        self.questionsValue.snp.makeConstraints { make in
            make.centerY.equalTo(self.questionsIcon.snp.centerY)
            make.right.equalToSuperview().inset(12)
            make.left.equalTo(self.questionsIcon.snp.right).inset(-8)
        }
        
        self.questionsTitle.snp.makeConstraints { make in
            make.bottom.right.left.equalToSuperview().inset(12)
        }
        
        self.ratingButton.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.videoButton.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.questionsButton.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        self.buttonsContainer.axis = .horizontal
        self.buttonsContainer.spacing = 8
        
        self.ratingContainer.round()
        self.ratingContainer.backgroundColor = .lightGrayBackground
        self.videoContainer.round()
        self.videoContainer.backgroundColor = .lightGrayBackground
        self.questionsContainer.round()
        self.questionsContainer.backgroundColor = .lightGrayBackground
        
        self.ratingTitle.style(.medium, 12)
        self.ratingTitle.textColor = .olchaBlue
        
        self.videoTitle.style(.medium, 12)
        self.videoTitle.textColor = .olchaBlue
        
        self.questionsTitle.style(.medium, 12)
        self.questionsTitle.textColor = .olchaBlue
        
        self.videoValue.style(.medium, 12)
        self.questionsValue.style(.medium, 12)
        
        self.videoIcon.image = .video
        self.questionsIcon.image = .question
        
        self.videoTitle.text = "video_reviews".localized()
        self.questionsTitle.text = "question_reviews".localized()
        
        self.ratingView.designCosmos(iconSize: 20)
        
        self.ratingButton.clicked { [weak self] in
            guard let self = self else { return }
            self.reviewButtonClicker?.send(.rating)
        }
        
        self.questionsButton.clicked { [weak self] in
            guard let self else { return }
            reviewButtonClicker?.send(.question)
        }
        
        videoContainer.isHidden = true
    }
    
    
    func setup(with data: ProductModel?,
               reviews: ReviewsData?,
               faqs: ReviewsData?
    ) {
        self.ratingView.rating = Double(data?.rating ?? 0)
        self.ratingTitle.text = (reviews?.paginator?.total ?? 0).string + " " + "reviews".localized()
        self.videoValue.text = "0"
        self.questionsValue.text = (faqs?.paginator?.total ?? 0).string
    }
    
}
