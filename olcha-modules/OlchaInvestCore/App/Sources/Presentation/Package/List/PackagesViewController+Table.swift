//
//  PackagesViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 24/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import SkeletonView

extension PackagesViewController: TableDelegates {
    
    public enum Section: CaseIterable {
        case package
    }
    
    public var sections: [Section] {
        [.package]
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        input.packagesSkeleton.getCount(input.packages.modelsCount)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PackagesTableCell.self, for: indexPath)
        cell.configure(skeleton: input.packagesSkeleton)
        guard input.packages.models.isGreater(indexPath) else {
            cell.prepareForReuse()
            return cell
        }
        let investment = input.packages.models[indexPath.row]
        cell.setup(with: investment)
        cell.detailsButtonClicked { [weak self] in
            guard let self, let id = investment.id else { return }
            self.pushPackagesDetailViewController(investmentId: id)
        }
        return cell
    }
}

extension PackagesViewController: SkeletonTableViewDataSource {
    public func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch sections[indexPath.section] {
        case .package: return PackagesTableCell.classIdentifier
        }
    }
}
