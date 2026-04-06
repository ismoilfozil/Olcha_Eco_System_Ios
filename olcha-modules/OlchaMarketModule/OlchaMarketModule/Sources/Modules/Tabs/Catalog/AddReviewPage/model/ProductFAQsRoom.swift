//
//  ProductFAQsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/08/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaCore
protocol InnerTableViewCellDelegate: AnyObject {
    func innerTableView(forIndex: IndexPath, atSize size: CGFloat)
}
class ProductFAQsRoom: BaseTableCell {

    
    private let table = DynamicTable()
    private let provider = FAQTableProvider()
    
    private var indexPath: IndexPath!
    
    weak var delegate: InnerTableViewCellDelegate?
    let outerTableReloader = PassthroughSubject<Bool, Never>()
    weak var pushAllFAQs: PassthroughSubject<Bool, Never>?
    weak var likeObserver: PassthroughSubject<(Comment?, LikeSegment.Value), Never>?
    weak var pushFaqReplies: PassthroughSubject<Comment?, Never>?
    private var bag = Set<AnyCancellable>()
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func configureViews() {
        table.isScrollEnabled = false
        provider.table = table
        provider.isShrinked = true
        provider.outerTableReloader = outerTableReloader
        
        outerTableReloader.sink { [weak self] canReload in
            guard let self = self else { return }
            self.updateOuterTableView()
        }.store(in: &bag)
        
    }
    
    
    func setup(with data: ReviewsData?) {
        provider.faqs = data?.comments ?? []
        provider.totalCount = data?.paginator?.total ?? 0
        provider.pushAllFAQs = pushAllFAQs
        provider.pushFaqReplies = pushFaqReplies
        provider.likeObserver = likeObserver
    }
    
    
    func configuration(indexPath: IndexPath, delegate: InnerTableViewCellDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        
        table.reloadData { [weak self] in
            guard let self = self else { return }
            self.updateOuterTableView()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateOuterTableView()
    }
    
    func updateOuterTableView() {
        
        delegate?.innerTableView(forIndex: indexPath,
                                 atSize: table.contentSize.height)
        
    }
}

class ProductFAQsRoomView: BaseTableCellView {

    var reviewsData: ReviewsData?
    private let table = DynamicTable()
    private let provider = FAQTableProvider()
    
    weak var mainTableReloader: PassthroughSubject<ProductPage.Sections, Never>?
    weak var delegate: InnerTableViewCellDelegate?
    let outerTableReloader = PassthroughSubject<Bool, Never>()
    weak var pushAllFAQs: PassthroughSubject<Bool, Never>?
    weak var likeObserver: PassthroughSubject<(Comment?, LikeSegment.Value), Never>?
    weak var pushFaqReplies: PassthroughSubject<Comment?, Never>?
    private var bag = Set<AnyCancellable>()
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func configureViews() {
        table.isScrollEnabled = false
        provider.table = table
        provider.isShrinked = true
        
        outerTableReloader.sink { [weak self] canReload in
            guard let self = self else { return }
            self.updateOuterTableView()
        }.store(in: &bag)
        
    }
    
    
    func setup(with data: ReviewsData?) {
        self.reviewsData = data
        provider.totalCount = data?.paginator?.total ?? 0
        provider.pushAllFAQs = pushAllFAQs
        provider.pushFaqReplies = pushFaqReplies
        provider.likeObserver = likeObserver
        provider.outerTableReloader = outerTableReloader
        provider.faqs = data?.comments ?? []
        updateOuterTableView()
    }
    
    
    func configuration(indexPath: IndexPath, delegate: InnerTableViewCellDelegate) {
        self.delegate = delegate
        
        table.reloadData { [weak self] in
            guard let self = self else { return }
            self.updateOuterTableView()
        }
    }
    
    func updateOuterTableView() {
        table.frame.size.height = table.contentSize.height
        table.frame.size = table.sizeThatFits(.zero)
        
        table.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(table.contentSize.height)
        }
    }
}
