//
//  AllQuestionsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/08/22.
//

import UIKit
import Combine
import OlchaUI

class AllQuestionsPage: BaseViewController {
    
    private let table = UITableView()
    
    //MARK: - LOGIC
    private let viewModel = ReviewsPageViewModel()
    private let provider = FAQTableProvider()
    let pushFaqReplies = PassthroughSubject<Comment?, Never>()
    let likeObserver = PassthroughSubject<(Comment?, LikeSegment.Value) , Never>()
    let loadObserver = PassthroughSubject<Int, Never>()
    private var bag = Set<AnyCancellable>()
    
    var faqs: [Comment] = []
    
    var product: ProductModel?
    var currentPage = 1
    var totalPage = 1
    var isLoading = false
    
    weak var coordinator: ReviewCoordinatorProtocol?
    
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
        
        navigation.setTitle("questions".localized())
        provider.table = self.table
        provider.likeObserver = likeObserver
        provider.loadMore = loadObserver
        provider.pushFaqReplies = pushFaqReplies
        table.showsVerticalScrollIndicator = false
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        handle(viewModel.$faqs, success: { [weak self] data in
            guard let self else { return }
            viewModel.reviewsIndicator.send(false)
            totalPage = data?.paginator?.last_page ?? 1
            currentPage = data?.paginator?.current_page ?? 1
            isLoading = false
            provider.faqs.append(contentsOf: data?.comments ?? [])
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
        
        viewModel.$faqsError.sink { [weak self] isError in
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
        
        viewModel.reviewsIndicator.sink { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.showCenterProgress() : self.hideCenterProgress()
        }.store(in: &bag)
        
        pushFaqReplies.sink { [weak self] question in
            guard let self = self else { return }
            self.coordinator?.pushFAQReplies(question: question, product: self.product)
        }.store(in: &bag)
        
    }
    
    override func initialRequest() {
        super.initialRequest()
        viewModel.reviewsIndicator.send(true)
        loadFAQs()
    }
    
    func loadFAQs() {
        guard let id = product?.id else { return }
        isLoading = true
        viewModel.loadFAQs(productID: id, page: currentPage)
    }
    
    func loadMore(index: Int) {
        if ((provider.faqs.count-2) == index) && !isLoading {
            currentPage += 1
            if currentPage <= totalPage {
                loadFAQs()
            }
        }
    }
}
