//
//  MyReviewsViewController+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/03/23.
//

import UIKit
extension MyReviewsPage: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentType == .review {
            return reviews.count
        } else {
            return questions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeue(MyReviewRoom.self, for: indexPath)
        cell.type = currentType
        cell.reviewView.pushReviewMedia = pushReviewMedia
        
        cell.reviewView.pushReviewReplies = pushReviewReplies
        cell.questionView.pushFaqReplies = pushReviewReplies
        
        cell.pushProduct = pushProduct
        
        
        if currentType == .review {
            if reviews.isGreater(indexPath) {
                cell.setup(with: reviews[indexPath.row])
            }
        } else {
            if questions.isGreater(indexPath) {
                cell.setup(with: questions[indexPath.row])
            }
        }
        
        loadMore(index: indexPath.row)
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentType == .review {
            if reviews.isGreater(indexPath) {
                coordinator?.pushEditReview(review: reviews[indexPath.row])
            }
        }
    }
}
