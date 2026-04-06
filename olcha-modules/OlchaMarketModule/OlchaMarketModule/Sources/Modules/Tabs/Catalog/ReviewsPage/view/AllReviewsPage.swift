//
//  AllReviewsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/08/22.
//

import UIKit
import Combine
import OlchaUI

class AllReviewsPage: BaseViewController {
    
    private let table = UITableView()
    
    weak var coordinator: ReviewCoordinatorProtocol?
    
    private var bag = Set<AnyCancellable>()
    private let viewModel = ReviewsPageViewModel()
    
    var currentPage = 1
    var totalPage = 1
    var isLoading = false
    
    private let provider = ReviewsTableProvider()
    
    let likeObserver = PassthroughSubject<(Comment?, LikeSegment.Value) , Never>()
    let loadObserver = PassthroughSubject<Int, Never>()
    let pushReviewReplies = PassthroughSubject<Comment?, Never>()
    let pushReviewMedia = PassthroughSubject<(Comment, Int), Never>()
    
    var reviews : [Comment] = []
    var product: ProductModel?
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(table)
    }
    
    override func autolayout() {
        super.autolayout()
        table.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        navigation.setTitle("review".localized())
        provider.table = table
        provider.likeObserver = likeObserver
        provider.loadMore = loadObserver
        provider.pushReviewMedia = pushReviewMedia
        table.showsVerticalScrollIndicator = false
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        handle(viewModel.$reviews, success: { [weak self] data in
            guard let self else { return }
            viewModel.reviewsIndicator.send(false)
            currentPage = data?.paginator?.current_page ?? 1
            totalPage = data?.paginator?.last_page ?? 1
            isLoading = false
            provider.totalCount = data?.paginator?.total ?? 0
            provider.reviews.append(contentsOf: data?.comments ?? [])
        })
        
        likeObserver.sink { [weak self] val in
            guard let self = self else { return }
            coordinator?.pushAuth {
                if let id = val.0?.id {
                    if val.1 == .liked {
                        self.viewModel.likeComment(with: id)
                    }
                    
                    if val.1 == .disliked {
                        self.viewModel.dislikeComment(with: id)
                    }
                }
            }
        }.store(in: &bag)
        
        viewModel.$reviewsError.sink { [weak self] isError in
            guard let self = self else { return }
            if isError {
                self.isLoading = false
                self.currentPage -= 1
            }
        }.store(in: &bag)
        
        loadObserver.sink { [weak self] index in
            guard let self = self else { return }
            self.loadMore(index: index)
        }.store(in: &bag)
        
        pushReviewReplies.sink { [weak self] review in
            guard let self = self else { return }
            self.coordinator?.pushReviewReplies(review: review, product: self.product)
        }.store(in: &bag)
        
        
        viewModel.reviewsIndicator.sink { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.showCenterProgress() : self.hideCenterProgress()
        }.store(in: &bag)
        
        pushReviewMedia.sink { [weak self] (val) in
            guard let self = self else { return }
            self.coordinator?.pushReviewMedia(review: val.0, index: val.1)
        }.store(in: &bag)
    }
    
    override func initialRequest() {
        super.initialRequest()
        viewModel.reviewsIndicator.send(true)
        loadReviews()
    }
    
    func loadReviews() {
        guard let id = product?.id else { return }
        isLoading = true
        viewModel.loadReviews(productID: id, page: currentPage)
    }
    
    func loadMore(index: Int) {
        
        if ((provider.reviews.count-2) == index) && !isLoading {
            currentPage += 1
            if currentPage <= totalPage {
                loadReviews()
            }
        }
    }
}
