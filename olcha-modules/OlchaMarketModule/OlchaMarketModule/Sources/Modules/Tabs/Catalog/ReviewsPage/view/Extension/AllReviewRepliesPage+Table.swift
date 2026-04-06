//
//  AllReviewsPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/08/22.
//

import UIKit
import OlchaUI
extension AllReviewRepliesPage: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        1 + (replies.count)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return (replies[section-1].child?.count ?? 0) + 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return reviewCell(tableView, cellForRowAt: indexPath)
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    private func reviewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> BaseTableCell {
        let section = indexPath.section - 1
        let index = indexPath.row - 1
        if indexPath.section == 0 {
            let cell = tableView.dequeue(ProductMainReviewItem.self, for: indexPath)
            
            cell.responder.likeObserver = likeObserver
            cell.responder.setup(with: review)
            cell.responder.pushReviewMedia = pushReviewMedia
            cell.responder.configureHeaderReview()
            return cell
        } else {
            let cell = tableView.dequeue(ProductReplyReviewItem.self, for: indexPath)
            
            cell.responder.pushReviewMedia = pushReviewMedia
            cell.responder.likeObserver = likeObserver
            var reviewItem: Comment? = replies[section]
            if indexPath.row != 0 {
                reviewItem = replies[section].child?[index]
            }
            
            if let reviewItem = reviewItem {
                cell.responder.setup(with: reviewItem)
            }
            
            cell.responder.replyName = replies[section].user?.name ?? ""
            return cell
        }
    }
    
}
