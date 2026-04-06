//
//  AllReplyQuestionsPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/03/23.
//
import OlchaUI

import UIKit
extension AllQuestionRepliesPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1 + (replies.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return (replies[section-1].child?.count ?? 0) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return reviewCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    private func reviewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> BaseTableCell {
        let section = indexPath.section - 1
        let index = indexPath.row - 1
        if indexPath.section == 0 {
            let cell = tableView.dequeue(ProductMainFAQItem.self, for: indexPath)
            cell.responder.likeObserver = likeObserver
            cell.responder.setup(with: faq)
            cell.responder.configureHeader()
            return cell
        } else {
            let cell = tableView.dequeue(ProductReplyFAQItem.self, for: indexPath)
            cell.responder.likeObserver = likeObserver
            
            var faqItem: Comment? = replies[section]
            if indexPath.row != 0 {
                faqItem = replies[section].child?[index]
            }
            
            if let faqItem = faqItem {
                cell.responder.setup(with: faqItem)
            }
            
            cell.responder.replyName = replies[section].user?.name ?? ""
            
            cell.responder.replyButton.clicked { [weak self] in
                guard let self = self else { return }
                self.repliedFAQ = faqItem
            }
            
            return cell
        }
    }
    
}
