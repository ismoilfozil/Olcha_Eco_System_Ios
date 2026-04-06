//
//  ProductReviewsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//

import UIKit
import Cosmos
import Combine
import OlchaUI
class ProductReviewsRoom: BaseTableCell {
    
    private let provider = ReviewsTableProvider()
    
    private let reviewsTable = DynamicTable()
    
    var reviewsData: ReviewsData?
    
    weak var mainTableReloader: PassthroughSubject<ProductPage.Sections, Never>?
    weak var likeObserver: PassthroughSubject<(Comment?, LikeSegment.Value), Never>?
    weak var pushReviewReplies: PassthroughSubject<Comment?, Never>?
    weak var pushReviewMedia: PassthroughSubject<(Comment, Int), Never>?
    weak var pushAllReviews: PassthroughSubject<Bool, Never>?
    weak var delegate: InnerTableViewCellDelegate?
    
    let outerTableReloader = PassthroughSubject<Bool, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    private var indexPath: IndexPath?
    
    override func setupViews() {
        container.addSubview(reviewsTable)
    }
    
    override func autolayout() {
        
        self.reviewsTable.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
    }
    
    override func configureViews() {
        reviewsSectionConfiguration()
        
        outerTableReloader.sink { [weak self] canReload in
            guard let self = self else { return }
            self.updateOuterTableView()
        }.store(in: &bag)
    }
    
    private func reviewsSectionConfiguration() {
        self.reviewsTable.isScrollEnabled = false
        self.provider.table = reviewsTable
        self.provider.isShrinked = true
    }
    
    func setup(with data: ReviewsData?, product: ProductModel?, reviewFiles: ReviewFilesData?) {
        self.provider.totalCount = data?.paginator?.total ?? 0
        
//        self.provider.pushReviewMedia = pushReviewMedia
        self.provider.pushAllReviews = pushAllReviews
        self.provider.likeObserver = likeObserver
        self.provider.pushReviewReplies = pushReviewReplies
        self.provider.outerTableReloader = outerTableReloader
        
        self.provider.reviews = data?.comments ?? []
    }

    func configuration(indexPath: IndexPath, delegate: InnerTableViewCellDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        
        reviewsTable.reloadData { [weak self] in
            guard let self = self else { return }
            self.updateOuterTableView()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateOuterTableView()
    }
    
    func updateOuterTableView() {
        guard let indexPath = indexPath else { return }
        
        self.delegate?.innerTableView(forIndex: indexPath,
                                      atSize: reviewsTable.contentSize.height)
    }
}

class ProductReviewsRoomView: BaseTableCellView {
    
    private let provider = ReviewsTableProvider()
    
    private let reviewsTable = DynamicTable()
    
    var reviewsData: ReviewsData?
    
    weak var mainTableReloader: PassthroughSubject<ProductPage.Sections, Never>?
    weak var likeObserver: PassthroughSubject<(Comment?, LikeSegment.Value), Never>?
    weak var pushReviewReplies: PassthroughSubject<Comment?, Never>?
    weak var pushReviewMedia: PassthroughSubject<(Comment, Int), Never>?
    weak var pushAllReviews: PassthroughSubject<Bool, Never>?
    weak var delegate: InnerTableViewCellDelegate?
    
    let outerTableReloader = PassthroughSubject<Bool, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    private var indexPath: IndexPath?
    
    override func setupViews() {
        container.addSubview(reviewsTable)
    }
    
    override func autolayout() {
        
        self.reviewsTable.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
    }
    
    override func configureViews() {
        reviewsSectionConfiguration()
        
        outerTableReloader.sink { [weak self] canReload in
            guard let self = self else { return }
            self.updateOuterTableView()
        }.store(in: &bag)
    }
    
    private func reviewsSectionConfiguration() {
        self.reviewsTable.isScrollEnabled = false
        self.provider.table = reviewsTable
        self.provider.isShrinked = true
    }
    
    func setup(with data: ReviewsData?, product: ProductModel?, reviewFiles: ReviewFilesData?) {
        self.provider.totalCount = data?.paginator?.total ?? 0
        
        self.provider.pushReviewMedia = pushReviewMedia
        self.provider.pushAllReviews = pushAllReviews
        self.provider.likeObserver = likeObserver
        self.provider.pushReviewReplies = pushReviewReplies
        self.provider.outerTableReloader = outerTableReloader
        
        self.provider.reviews = data?.comments ?? []
    }

    func configuration(indexPath: IndexPath, delegate: InnerTableViewCellDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        
        reviewsTable.reloadData { [weak self] in
            guard let self = self else { return }
            self.updateOuterTableView()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateOuterTableView()
    }
    
    func updateOuterTableView() {
        guard let indexPath = indexPath else { return }
        
        self.delegate?.innerTableView(forIndex: indexPath,
                                      atSize: reviewsTable.contentSize.height)
    }
}
