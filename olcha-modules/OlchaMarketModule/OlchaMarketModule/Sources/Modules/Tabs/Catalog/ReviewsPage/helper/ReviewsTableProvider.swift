//
//  ReviewViewModelHelper.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/08/22.
//

import UIKit
import Combine
import OlchaUI

class ReviewsTableProvider: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var maxCount = 2
    
    var isShrinked = false
    
    var reviews: [Comment] = [] {
        didSet {
            table?.reloadData()
        }
    }
    
    var totalCount = 0
    weak var pushReviewMedia: PassthroughSubject<(Comment, Int), Never>?
    weak var pushReviewReplies: PassthroughSubject<Comment?, Never>?
    weak var pushAllReviews: PassthroughSubject<Bool, Never>?
    weak var loadMore: PassthroughSubject<Int, Never>?
    weak var likeObserver: PassthroughSubject<(Comment?, LikeSegment.Value), Never>?
    weak var outerTableReloader: PassthroughSubject<Bool, Never>?
    
    weak var table: UITableView? {
        didSet {
            table?.delegate = self
            table?.dataSource = self
            table?.registerClass(forCell: ProductMainReviewItem.self)
            table?.registerClass(forCell: ProductReplyReviewItem.self)
            table?.configure()
            table?.registerClass(forCell: ShowAllReviewsItem.self)
            table?.separatorStyle = .none
            table?.estimatedRowHeight = 44.0
            table?.rowHeight = UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = reviews.count
        
        if isShrinked && count > maxCount {
            return maxCount + 1
        } else {
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadMoreItem(section) {
            return 1
        }
        
        ///in product page removing last items separator
        let headerCount = 1
        let mainFAQCount = 1
        let repliesCount = reviews[section].child?.count ?? 0
        
        return headerCount + mainFAQCount + repliesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoadMoreItem(indexPath.section) {
            let cell = tableView.dequeue(ShowAllReviewsItem.self, for: indexPath)
            cell.withEdge = true
            cell.type = .review
            cell.setup(with: totalCount.string)
            outerTableReloader?.send(true)
            return cell
        }
        
        let headerIndex = 0
        let mainReviewIndex = 1
        
        let replyIndex = indexPath.row - 2
        loadMore?.send(indexPath.section)
        
        
        if indexPath.row == mainReviewIndex {
            let cell = tableView.dequeue(ProductMainReviewItem.self, for: indexPath)
            cell.responder.likeObserver = likeObserver
            cell.responder.pushReviewMedia = pushReviewMedia
            cell.responder.setup(with: self.reviews[indexPath.section])
            outerTableReloader?.send(true)
            return cell
        } else if indexPath.row == headerIndex {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            
            cell.responder.withSeparator = true
            cell.responder.withEdge = true
            cell.responder.height = 9
            
            outerTableReloader?.send(true)
            return cell
        } else {
            let cell = tableView.dequeue(ProductReplyReviewItem.self, for: indexPath)
            cell.responder.pushReviewMedia = pushReviewMedia
            cell.responder.likeObserver = likeObserver
            if let reply = self.reviews[indexPath.section].child?[replyIndex] {
                cell.responder.replyName = self.reviews[indexPath.section].user?.name ?? ""
                cell.responder.setup(with: reply)
            }

            outerTableReloader?.send(true)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if isLoadMoreItem(indexPath.section) {
            pushAllReviews?.send(true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoadMoreItem(indexPath.section) {
            return 40
        }
        
        return UITableView.automaticDimension
        
    }
    
    private func isLoadMoreItem(_ section: Int) -> Bool {
        return (section == (maxCount)) && isShrinked
    }
}
