//
//  ReviewsPageViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//

import Foundation
import Combine
import OlchaUI
import OlchaCore
import OlchaAuth
import OlchaUtils
public class ReviewsPageViewModel: OldBaseViewModel {
    
    @Published var reviews: LoadingState<ReviewsData, BaseErrorType> = .standart
    @Published var reviewFilesError: Bool = false
    @Published var reviewFiles: LoadingState<ReviewFilesData, BaseErrorType> = .standart
    @Published var images: [File] = []
    @Published var videos: [Video] = []
    @Published var reloadTable = false
    @Published var reviewSuccess = false
    @Published var editReviewSuccess = false
    @Published var questionSuccess = false
    @Published var faqs: LoadingState<ReviewsData, BaseErrorType> = .standart
    @Published var faqsError: Bool = false
    @Published var reviewsError: Bool = false
    
    @Published var reviewReplySuccess = false
    @Published var reviewReplyError = false
    
    @Published var myReviews: ReviewsData?
    @Published var myReviewsError: Bool?
    @Published var myQuestions: ReviewsData?
    
    let reviewsIndicator = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    
    func loadReviews(productID: Int, page: Int = 1) {
        reviews  = .loading
        let api: ReviewsAPI = .reviews(id: productID, page: page)
        self.startRequesting(api: api) { [weak self] (data: ReviewsData?) in
            guard let self = self else { return }
            reviews = .success(data)
        } onError: { [weak self] msg in
            guard let self = self else { return }
            self.reviewsError = true
            self.show(error: msg)
            reviews = .failure(.init(message: msg))
        }
    }
    
    func loadFAQs(productID: Int, page: Int = 1) {
        faqs = .loading
        let api: ReviewsAPI = .faqs(id: productID, page: page)
        self.startRequesting(api: api) { [weak self] (data: ReviewsData?) in
            guard let self = self else { return }
            faqs = .success(data)
        } onError: { [weak self] error in
            guard let self else { return }
            faqs = .failure(.init(message: error))
        }
        
    }
    
    func loadReviewsFiles(productID: Int, page: Int = 1) {
        reviewFiles = .loading
        let api: ReviewsAPI = .reviewsFiles(id: productID, page: page)
        self.startRequesting(api: api) { [weak self] (data: ReviewFilesData?) in
            guard let self = self else { return }
            reviewFiles = .success(data)
        } onError: { [weak self] msg in
            guard let self = self else { return }
            self.reviewFilesError = true
            self.show(error: msg)
            reviewFiles = .failure(.init(message: msg))
        }
    }
    
    func likeComment(with id: Int) {
        let api: ReviewsAPI = .like(commentID: id)
        self.startRequesting(api: api) { (data: EmptyData?) in }
    }
    
    func dislikeComment(with id: Int) {
        let api: ReviewsAPI = .dislike(commentID: id)
        self.startRequesting(api: api) { (data: EmptyData?) in }
    }
    
    func send(question: String, productID: Int, repliedID: Int) {
        let api: ReviewsAPI = .sendReplyFAQ(productID: productID, question: question, repliedID: repliedID)
        self.startRequesting(api: api) { [weak self] (data: EmptyData?) in
            guard let self = self else { return }
            self.questionSuccess = true
        } onError: { [weak self] msg in
            guard let self = self else { return }
            self.questionSuccess = false
            self.show(error: msg)
        }
    }
    
    func send(question: String, productID: Int) {
        let api: ReviewsAPI = .sendFAQ(productID: productID, question: question)
        self.startRequesting(api: api) { [weak self] (data: EmptyData?) in
            guard let self = self else { return }
            self.questionSuccess = true
        } onError: { [weak self] msg in
            guard let self = self else { return }
            self.questionSuccess = false
            self.show(error: msg)
        }
    }
    
    func sendReview(productID: Int, observers: AddReviewObserver) {

        let api: ReviewsAPI = .sendReview(
            model: .init(review: observers.productReview,
                         product_id: productID,
                         rating: observers.productRating.rawValue.double,
                         files: images.compactMap { $0.id },
                         order_id: nil,
                         services: observers.getServiceRatings(),
                         anonymous: observers.isAnonym))
        self.startRequesting(api: api) { [weak self] (data: EmptyData?) in
            guard let self = self else { return }
            self.reviewSuccess = true
        } onError: { [weak self] msg in
            guard let self = self else { return }
            self.reviewSuccess = false
            self.show(error: msg)
        }
    }
    
    func editReview(reviewID: Int, observers: AddReviewObserver) {
        let api: ReviewsAPI = .editReview(
            model: .init(review_id: reviewID,
                         review: observers.productReview,
                         rating: observers.productRating.rawValue.double,
                         files: images.compactMap { $0.id })
        )
        self.startRequesting(api: api) { [weak self] (data: EmptyData?) in
            guard let self else { return }
            editReviewSuccess = true
        } onError: { [weak self] message in
            guard let self else { return }
            editReviewSuccess = false
            show(error: message)
        }
    }
    
    func sendReview(productID: Int, review: String, repliedID: Int) {
        let api: ReviewsAPI = .sendReplyReview(productID: productID, review: review, repliedID: repliedID)
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: EmptyData?) in
            guard let self = self else { return }
            self.reviewReplySuccess = true
        } onError: { [weak self] msg in
            guard let self = self else { return }
            self.show(error: msg)
        }
    }

    func loadMyReviews(_ page: Int) {
        let api: ReviewsAPI = .myReviews(page: page)
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: ReviewsData?) in
            guard let self = self else { return }
            self.myReviews = data
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
            self.myReviewsError = true
        }
    }
    
    func loadMyFAQs(_ page: Int) {
        let api: ReviewsAPI = .myFAQs(page: page)
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: ReviewsData?) in
            guard let self = self else { return }
            self.myQuestions = data
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
            self.myReviewsError = true
        }
    }
}
