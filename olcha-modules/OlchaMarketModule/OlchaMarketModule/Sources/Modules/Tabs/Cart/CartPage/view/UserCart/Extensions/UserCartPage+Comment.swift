//
//  UserCartPage+Comment.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 28/06/24.
//

import UIKit
extension UserCartPage {
    
    func commentObservers() {
        commentTextView.commentObserver = { [weak self] comment in
            guard let self else { return }
            acceptComment(comment: comment)
        }
        
        commentContainerView.clicked { [weak self] in
            guard let self else { return }
            cancelComment()
        }
    }
    
    func showEnterComment() {
        commentTextView.initialComment = observers.comment ?? ""
        commentContainerView.isHidden = false
        commentContainerView.isUserInteractionEnabled = true
//        commentTextView.openKeyboard()
    }
    
    private func acceptComment(comment: String?) {
        observers.comment = comment
        commentTextView.clearComment()
        hideCommentView()
        table.reloadData()
    }
    
    private func cancelComment() {
        commentTextView.clearComment()
        hideCommentView()
    }
    
    func hideCommentView() {
        commentContainerView.isHidden = true
        commentContainerView.isUserInteractionEnabled = false
    }
}
