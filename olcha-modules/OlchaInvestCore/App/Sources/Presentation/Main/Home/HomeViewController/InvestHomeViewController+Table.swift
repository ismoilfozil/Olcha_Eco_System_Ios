//
//  InvestHomeViewController+Table.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit
import OlchaUI
import SkeletonView

extension InvestHomeViewController: TableDelegates {
    
    public enum Section: CaseIterable {
        case invest, addInvest, pagination
    }
    
    public var sections: [Section] {
        [
            .invest,
            input.invests.models.isEmpty ? nil : .addInvest,
            .pagination
        ].compactMap({ $0 })
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .invest: return input.investsSkeleton.getCount(input.invests.modelsCount)
        case .addInvest: return 1
        case .pagination: return input.invests.paging.footerLoadingCount()
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .invest:
            let cell = tableView.dequeue(InvestHomeTableCell.self, for: indexPath)
            cell.configure(skeleton: input.investsSkeleton)
            guard input.invests.models.isGreater(indexPath) else {
                cell.prepareForReuse()
                return cell
            }
            let model = input.invests.models[indexPath.row]
            cell.setup(with: model)
            cell.detailsButtonClicked { [weak self] in
                self?.pushContractViewController(model: model)
            }
            cell.withdrawalButtonClicked { [weak self] in
                self?.pushInvestProfitViewController(model: model)
            }
            
            loadMore(index: indexPath.row)
            return cell
        case .addInvest:
            let cell = tableView.dequeue(InvestHomeAddTableCell.self, for: indexPath)
            cell.setup()
            return cell
        case .pagination:
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.configureIndicator()
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .addInvest:
            pushInvestViewController()
        default: break
        }
    }
    
    
    
}

extension InvestHomeViewController: SkeletonTableViewDataSource {
    public func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch sections[indexPath.section] {
        case .invest: return InvestHomeTableCell.classIdentifier
        case .addInvest: return InvestHomeAddTableCell.classIdentifier
        case .pagination: return FooterItem.classIdentifier
        }
    }
}
