//
//  ReviewCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/08/22.
//

import UIKit
import PhotosUI
import Combine
import AVKit
import OlchaUI
import OlchaUtils
public protocol ReviewCoordinatorProtocol : Coordinator {
    func pushReviewMedia(product: ProductModel?, reviewsData: ReviewFilesData?, index: Int)
    func pushReviewMedia(review: Comment?, index: Int)
    func presentMediaType(mediaType: MediaPicker.MediaType,
                          imageObserver: PassthroughSubject<UIImage?, Never>,
                          videoObserver: PassthroughSubject<Video?, Never>)
    func presentVideoPlayer(video: Video)
    func pushAddReview(product: ProductModel?)
    func pushEditReview(review: Comment)
    func pushAskQuestion(product: ProductModel?)
    func pushReviewFinish(type: ReviewType, lastPage: UIViewController.Type?)
    func pushAllFAQs(product: ProductModel?)
    func pushReviewReplies(review: Comment?, product: ProductModel?)
    func pushFAQReplies(question: Comment?, product: ProductModel?)
    func pushAllReviews(product: ProductModel?)
    func dismissToProductPage(lastPage: UIViewController.Type?)
    func pushAuth(completion: (() -> Void)?)
}
public class ReviewCoordinator : OlchaMainCoordinator, ReviewCoordinatorProtocol, UIImagePickerControllerDelegate {
    private var picker: MediaPicker?
    public var lastPage: UIViewController.Type?
    
    public override func start() {}
    
    public func pushAddReview(product: ProductModel?) {
        authCoordinator.pushAuth(isSet: false) { [weak self] in
            guard let self = self else { return }
            let vc = AddReviewPage()
            vc.product = product
            vc.coordinator = self
            self.navigationController.push(vc)
        }
    }
    
    public func pushEditReview(review: Comment) {
        let vc = AddReviewPage()
        vc.coordinator = self
        vc.setupEditingReview(review: review)
        navigationController.push(vc)
    }
    
    public func pushAskQuestion(product: ProductModel?) {
        authCoordinator.pushAuth(isSet: false) { [weak self] in
            guard let self = self else { return }
            let vc = AskQuestionPage()
            vc.coordinator = self
            vc.product = product
            self.navigationController.push(vc)
        }
    }
    
    public func pushReviewMedia(product: ProductModel?, reviewsData: ReviewFilesData?, index: Int) {
        let vc = ReviewMediaPage()
        vc.hidesBottomBarWhenPushed = true
        vc.coordinator = self
        vc.currentFile = index
        vc.product = product
        vc.viewModel.reviewFiles = .success(reviewsData)
        navigationController.push(vc)
    }
    
    public func pushReviewMedia(review: Comment?, index: Int) {
        let vc = ReviewMediaPage()
        vc.hidesBottomBarWhenPushed = true
        vc.coordinator = self
        vc.currentFile = index
        vc.comment = review
        vc.files = review?.files ?? []
        
        navigationController.push(vc)
    }
    
    public func presentMediaType(mediaType: MediaPicker.MediaType,
                                 imageObserver: PassthroughSubject<UIImage?, Never>,
                                 videoObserver: PassthroughSubject<Video?, Never>) {
        
        let vc = MediaTypeModalPage()
        
        vc.mediaClicked = { [weak self] type in
            guard let self = self else { return }
            self.mediaPicker(type: mediaType,
                             sourceType: type,
                             imageObserver: imageObserver,
                             videoObserver: videoObserver)
        }
        
        navigationController.presentModally(vc)
    }
    
    private func mediaPicker(type: MediaPicker.MediaType,
                             sourceType: UIImagePickerController.SourceType,
                             imageObserver: PassthroughSubject<UIImage?, Never>?,
                             videoObserver: PassthroughSubject<Video?, Never>?) {
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
        picker = MediaPicker()
        picker?.mediaType = type
        picker?.selectedImageObserver = imageObserver
        picker?.selectedVideoObserver = videoObserver
        picker?.present(navigationController: navigationController, sourceType: sourceType)
    }
 
    public func presentVideoPlayer(video: Video) {
        let file = File(file_extension: nil,
                        file_name: nil,
                        file_path: nil,
                        file_size: nil,
                        full_path: video.url?.absoluteString,
                        id: nil,
                        mime_type: MediaPicker.MediaMimeType.video.rawValue)

        let vc = ReviewMediaPage()
        vc.files = [file]
        vc.coordinator = self
        navigationController.present(vc, animated: true)
    }
    
    public func pushReviewFinish(type: ReviewType, lastPage: UIViewController.Type?) {
        let vc = ReviewFinishPage()
        vc.lastPage = lastPage
        vc.reviewType = type
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    public func pushAllFAQs(product: ProductModel?) {
        let vc = AllQuestionsPage()
        vc.coordinator = self
        vc.product = product
        navigationController.push(vc)
    }
    
    public func pushReviewReplies(review: Comment?, product: ProductModel?) {
        let vc = AllReviewRepliesPage()
        vc.hidesBottomBarWhenPushed = true
        vc.coordinator = self
        vc.product = product
        vc.review = review
        navigationController.push(vc)
    }
    
    public func pushFAQReplies(question: Comment?, product: ProductModel?) {
        let vc = AllQuestionRepliesPage()
        vc.hidesBottomBarWhenPushed = true
        vc.coordinator = self
        vc.product = product
        vc.faq = question
        navigationController.push(vc)
    }
    
    public func pushAllReviews(product: ProductModel?) {
        let vc = AllReviewsPage()
        vc.coordinator = self
        vc.product = product
        navigationController.push(vc)
    }
    
    public func dismissToProductPage(lastPage: UIViewController.Type?) {
        guard let lastPage else { return }
        navigationController.popLastViewController(to: lastPage.self)
    }
    
    public func pushAuth(completion: (() -> Void)?) {
        authCoordinator.pushAuth(isSet: false, completion: completion)
    }
}
