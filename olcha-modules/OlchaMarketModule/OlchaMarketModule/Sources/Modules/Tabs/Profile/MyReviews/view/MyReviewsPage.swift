//
//  MyReviewsViewController.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/03/23.
//

import UIKit
import Combine
import OlchaUI
import OlchaCore
class MyReviewsPage: BaseViewController {

    private let table = BaseTableView()
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    var reviews: [Comment] = []
    
    var questions: [Comment] = []
    
    private var bag = Set<AnyCancellable>()
    
    private let viewModel = ReviewsPageViewModel()
    
    let pushReviewMedia = PassthroughSubject<(Comment, Int), Never>()
    let pushReviewReplies = PassthroughSubject<Comment?, Never>()
    let pushProduct = PassthroughSubject<ProductModel?, Never>()
    
    public let reviewsPaginator = Paging()
    
    public let faqsPaginator = Paging()
    
    var currentType: ReviewType = .review
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        
        table.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
    }
    
    override func configureViews() {
        
        navigation.configure(style: .back)
        let title = currentType == .review ? "my_reviews" : "my_questions"
        navigation.setTitle(title.localized())
        
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: MyReviewRoom.self)
        table.configure()
        
        languageUpdated()
    }
    
    override func languageUpdated() {
        if currentType == .review {
            placeholder.setupTitle("empty_reviews".localized())
        } else {
            placeholder.setupTitle("empty_faqs".localized())
        }
        placeholder.setupButtonTitle()
        
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        viewModel
            .$myReviews
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self, self.currentType == .review else { return }
                self.reviewsPaginator.finished(paginator: data?.paginator)
                self.reviews.append(contentsOf: data?.comments ?? [])
                self.table.reloadData()
                self.checkEmptyPlaceholder()
            }.store(in: &bag)
        
        viewModel
            .$myQuestions
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self, self.currentType == .question else { return }
                self.faqsPaginator.finished(paginator: data?.paginator)
                self.questions.append(contentsOf: data?.comments ?? [])
                self.table.reloadData()
                self.checkEmptyPlaceholder()
            }.store(in: &bag)
        
        viewModel
            .$myReviewsError
            .sink { [weak self] isError in
                guard let self = self else { return }
                self.faqsPaginator.errorFinished()
                self.reviewsPaginator.errorFinished()
            }.store(in: &bag)
        
        pushReviewMedia.sink { [weak self] (val) in
            guard let self = self else { return }
            self.coordinator?.pushReviewMedia(review: val.0, index: val.1)
        }.store(in: &bag)
        
        pushProduct.sink { [weak self] data in
            guard let self = self else { return }
            self.coordinator?.pushProduct(product: data)
        }.store(in: &bag)
        
        
        placeholderButton { [weak self] in
            guard let self = self else { return }
            popToMainTab(mainTabIndex: OlchaTab.home)
        }
        
        pushReviewReplies.sink { [weak self] review in
            guard let self = self else { return }
            if self.currentType == .review {
                self.coordinator?.pushReviewReplies(review: review, product: review?.product)
            } else {
                self.coordinator?.pushFAQReplies(question: review, product: review?.product)
            }

        }.store(in: &bag)
        
    }
    
    override func initialRequest() {
        if currentType == .review {
            viewModel.loadMyReviews(1)
        } else {
            viewModel.loadMyFAQs(1)
        }
    }
    
    func loadMore(index: Int) {
        if currentType == .review {
            checkReviewPaginator(index: index)
        } else {
            checkQuestionsPaginator(index: index)
        }
    }

    func checkQuestionsPaginator(index: Int) {
        if index == (questions.count - 3) {
            if !faqsPaginator.isLoading {
                faqsPaginator.current = faqsPaginator.current + 1
                if faqsPaginator.current <= faqsPaginator.total {
                    loadMoreReviews()
                }
            }
        }
    }
    
    func checkReviewPaginator(index: Int) {
        if index == (reviews.count - 3) {
            if !reviewsPaginator.isLoading {
                reviewsPaginator.current = reviewsPaginator.current + 1
                if reviewsPaginator.current <= reviewsPaginator.total {
                    loadMoreReviews()
                }
            }
        }
    }
    
    func loadMoreReviews() {
        viewModel.loadMyReviews(reviewsPaginator.current)
    }
    
    func loadMoreQuestions() {
        viewModel.loadMyFAQs(faqsPaginator.current)
    }
    
    func checkEmptyPlaceholder() {
        if currentType == .review {
            reviews.isEmpty ? enablePlaceholder() : disablePlaceholder()
        } else {
            questions.isEmpty ? enablePlaceholder() : disablePlaceholder()
        }
    }
}
