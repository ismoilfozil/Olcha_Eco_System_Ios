//
//  SelectTermViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 26/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import SkeletonView

extension SelectTermViewController: TableDelegates {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        input.termsSkeleton.getCount(input.terms.modelsCount)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SelectTermTableCell.self, for: indexPath)
        cell.configure(skeleton: input.termsSkeleton)
        guard input.terms.models.isGreater(indexPath) else {
            cell.prepareForReuse()
            return cell
        }
        let cellData = input.terms.models[indexPath.row]
        cell.setup(with: cellData)
        cell.isChosen = output.term?.id == cellData.id
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard input.terms.models.isGreater(indexPath) else { return }
        output.term = input.terms.models[indexPath.row]
        changeContinueButton(to: output.term != nil)
        tableView.reloadData()
    }
    
}

extension SelectTermViewController: SkeletonTableViewDataSource {
    public func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SelectTermTableCell.classIdentifier
    }
}
