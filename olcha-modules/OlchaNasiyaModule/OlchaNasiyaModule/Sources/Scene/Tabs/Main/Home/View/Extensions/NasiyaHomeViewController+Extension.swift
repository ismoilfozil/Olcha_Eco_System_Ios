//
//  NasiyaHomeViewController+Extension.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import UIKit
import OlchaUI
extension NasiyaHomeViewController: TableDelegates {
    
    public enum Section {
        case balance
        case limit
        case banner
        case nextPayments
        case emptyPlaceholder
        case footerIndicator
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .balance:
            return 2
        case .limit:
            return 2
        case .banner:
            return getBannersCount()
        case .nextPayments:
            return getOrdersSkeleton()
        case .emptyPlaceholder:
            return getPlaceholderCount()
        case .footerIndicator:
            return getIndicatorCount()
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !isFooter(indexPath) else {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.withSeparator = false
            return cell
        }
        
        guard !isHeader(indexPath) else {
            let cell = tableView.dequeue(HeaderRoom.self, for: indexPath)
            cell.responder.setup(title: "next_payment".localized(.olchaNasiyaModule))
            return cell
        }
        
        switch sections[indexPath.section] {
        case .balance:
            
            let cell = tableView.dequeue(AmountBannersRoom.self, for: indexPath)
            cell.setup(balances: input.balances,
                       user: input.user,
                       limitBalance: input.limit?.installment_limit_balance)
            
            cell.pushFillBalance = output.pushFillBalance
            
            return cell
            
        case .limit:
            
            let cell = tableView.dequeue(ResetLimitRoom.self, for: indexPath)
            cell.setup(with: input.limit)
            cell.limitView.setup(status: input.verification?.status)
            cell.limitView.setRequestButton { [weak self] in
                guard let self = self else { return }
                homeViewModel.requestLimit()
            }
            
            return cell
            
        case .banner:
            let cell = tableView.dequeue(NasiyaBannerRoom.self, for: indexPath)
            cell.skeleton = input.bannersSkeleton
            cell.bannerClickObserver = output.bannerClickObserver
            cell.setup(banners: input.banners)
            return cell
        case .emptyPlaceholder:
            let cell = tableView.dequeue(EmptyNextPaymentRoom.self, for: indexPath)
            cell.verticalEdge = 16
            cell.setup()
            return cell
        case .nextPayments:
            let cell = tableView.dequeue(InstallmentRoom.self, for: indexPath)
            cell.configure(skeleton: input.ordersSkeleton)
            let index = indexPath.row - 1
            if output.filters.installments.models.isGreater(index) {
                cell.setup(with: output.filters.installments.models[index])
                cell.moreButton.settings.clicked { [weak self] in
                    guard let self = self
                    else { return }
                    
                    coordinator?.pushInstallment(installment: output.filters.installments.models[index])
                }
                loadMore(index)
            } else {
                cell.prepareForReuse()
            }
            return cell
        case .footerIndicator:
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.configureIndicator()
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if sections[indexPath.section] == .nextPayments {
            loadMore(indexPath.row)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard !isFooter(indexPath) else {
            return 20
        }
        return UITableView.automaticDimension
    }
    
    private func isFooter(_ indexPath: IndexPath) -> Bool {
        switch sections[indexPath.section] {
        case .balance:
            return (indexPath.row == 1)
        case .limit:
            return (indexPath.row == 1)
        case .banner:
            return (indexPath.row == 1)
        case .nextPayments:
            return false
        case .emptyPlaceholder:
            return (indexPath.row == 1)
        case .footerIndicator:
            return false
        }
    }
 
    private func isHeader(_ indexPath: IndexPath) -> Bool {
        switch sections[indexPath.section] {
        
        case .nextPayments:
            return indexPath.row == 0
        default:
            return false
        
        }
    }
    
}

fileprivate extension NasiyaHomeViewController {
    func getPlaceholderCount() -> Int {
        if input.ordersSkeleton.isAnimating {
            return 0
        } else {
            return output.filters.installments.models.isEmpty ? 2 : 0
        }
    }
    
    func getIndicatorCount() -> Int {
        if input.ordersSkeleton.isAnimating {
            return 0
        } else {
            return output.filters.installments.paging.footerLoadingCount()
        }
    }
    
    func getBannersCount() -> Int {
        input.bannersSkeleton.getCount(input.banners.count)
    }
    
    func getOrdersSkeleton() -> Int {
        return input.ordersSkeleton.getCount(output.filters.installments.modelsCount + 1)
    }
}
