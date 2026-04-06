//
//  FAQTableProvider.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/08/22.
//


import UIKit
import Combine

class FAQTableProvider: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let footerHeight: CGFloat = 40
    
    var isShrinked = false
    
    weak var table: UITableView? {
        didSet {
            table?.delegate = self
            table?.dataSource = self
            table?.registerClass(forCell: ShowAllReviewsItem.self)
            table?.registerClass(forCell: ProductMainFAQItem.self)
            table?.registerClass(forCell: ProductReplyFAQItem.self)
            table?.configure()
        }
    }
    
    weak var pushAllFAQs: PassthroughSubject<Bool, Never>?
    weak var likeObserver: PassthroughSubject<(Comment?, LikeSegment.Value), Never>?
    weak var pushFaqReplies: PassthroughSubject<Comment?, Never>?
    weak var pushReviewMedia: PassthroughSubject<(Comment, Int), Never>?
    weak var loadMore: PassthroughSubject<Int, Never>?
    weak var delegate: InnerTableViewCellDelegate?
    
    weak var outerTableReloader: PassthroughSubject<Bool, Never>?
    var totalCount = 0
    var faqs: [Comment] = [] {
        didSet {
            table?.reloadData()
        }
    }
    
    var maxCount: Int = 3
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = faqs.count
        if count > maxCount && isShrinked { return maxCount + 1 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isFooter(indexPath) {
            let cell = tableView.dequeue(ShowAllReviewsItem.self, for: indexPath)
            cell.type = .question
            cell.setup(with: totalCount.string)
            cell.withEdge = true
            return cell
        }
        loadMore?.send(indexPath.row)
        let cell = tableView.dequeue(ProductMainFAQItem.self, for: indexPath)
        cell.responder.setup(with: faqs[indexPath.row])
        cell.responder.likeObserver = likeObserver
        cell.responder.pushFaqReplies = pushFaqReplies
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFooter(indexPath) {
            return footerHeight
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isFooter(indexPath) {
            pushAllFAQs?.send(true)
        }
    }
    
    private func isFooter(_ indexPath: IndexPath) -> Bool {
        (indexPath.row == maxCount) && isShrinked
    }
}
