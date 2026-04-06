//
//  FaqViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 30/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import SkeletonView

extension FaqViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    
    public func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        FaqTableCell.classIdentifier
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        input.faqsSkeleton.getCount(input.faqs.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FaqTableCell.self, for: indexPath)
        cell.configure(skeleton: input.faqsSkeleton)
        guard input.faqs.isGreater(indexPath) else {
            return cell
        }
        cell.setup(with: input.faqs[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard input.faqs.isGreater(indexPath.row) else {
            return
        }
        input.faqs[indexPath.row].isExpanded = !(input.faqs[indexPath.row].isExpanded ?? false)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
