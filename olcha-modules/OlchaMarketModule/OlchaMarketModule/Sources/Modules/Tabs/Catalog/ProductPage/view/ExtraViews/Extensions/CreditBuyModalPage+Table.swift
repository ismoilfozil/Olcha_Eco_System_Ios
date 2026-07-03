//
//  CreditBuyModalPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/07/22.
//

import UIKit
import Combine
extension CreditBuyModalPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .products:
            return 1
        case .credits:
            return creditTypes.count
        case .externalProviders:
            return checkoutViewModel.externalProviders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .products:
            let cell = tableView.dequeue(CreditCountProductRoom.self, for: indexPath)
            cell.setup(with: product)
            cell.acceptClickObserver = acceptClickObserver
            cell.isReadyAccept = isReadyAccept
            cell.countObserver = countObserver
            cell.hideAcceptButton = true
            return cell
        case .credits:
            switch creditTypes[indexPath.row] {
            case .olcha:
                let cell = tableView.dequeue(OlchaCreditStoreRoom.self, for: indexPath)

                cell.isReady = isReadyAccept
                cell.isChosen = (creditOrder.creditType == .olcha && selectedExternalProvider == nil)
                cell.isBestOffer = isOlchaBestOffer()
                cell.creditOrder = creditOrder
                cell.expandeButton.clicked {
                    cell.isExpande = !cell.isExpande
                    cell.expandeButton.rotate(degree: .pi)

                    UIView.animate(withDuration: cell.isExpande ? 0 : 0.3) {
                        cell.contentView.layoutIfNeeded()
                        tableView.performBatchUpdates(nil, completion: nil)
                    }
                }

                cell.onPeriodChanged = nil
                cell.setup(with: [product].compactMap { $0 })
                cell.onSelected = { [weak self] in
                    guard let self else { return }
                    self.selectedExternalProvider = nil
                    self.selectedExternalPeriod = 0
                    self.creditOrder.externalInstalment = nil
                    self.creditOrder.creditType = .olcha
                    tableView.reloadData()
                }
                cell.setupTempData(preferredMonth: sharedPeriod)
                cell.onPeriodChanged = { [weak self, weak tableView] month in
                    guard let self else { return }
                    self.sharedPeriod = month
                    if let activeProvider = self.selectedExternalProvider,
                       activeProvider.sortedPeriods.contains(month) {
                        self.updateExternalInstallment(provider: activeProvider, period: month)
                    }
                    if let section = self.sections.firstIndex(of: .externalProviders) {
                        tableView?.reloadSections(IndexSet(integer: section), with: .none)
                    }
                }

                return cell
            case .anorbank:
                let cell = tableView.dequeue(AnorbankCreditStoreRoom.self, for: indexPath)
                cell.isChosen = (creditOrder.creditType == .anorbank)
                cell.isReady = isReadyAccept
                cell.creditOrder = creditOrder

                cell.setup(with: [product].compactMap { $0 })

                return cell
            }

        case .externalProviders:
            let providers = checkoutViewModel.externalProviders
            guard indexPath.row < providers.count else { return UITableViewCell() }
            let provider = providers[indexPath.row]
            let cell = tableView.dequeue(ExternalInstallmentStoreRoom.self, for: indexPath)
            let totalPrice = totalInstallmentPrice()
            let isSelected = selectedExternalProvider?.alias == provider.alias
            let initialPeriod = isSelected ? (supportedPeriod(for: provider) ?? selectedExternalPeriod) : supportedPeriod(for: provider)
            cell.setup(provider: provider, totalPrice: totalPrice, initialPeriod: initialPeriod)
            cell.isChosen = isSelected
            cell.onSelected = { [weak self] in
                guard let self else { return }
                let period = self.supportedPeriod(for: provider) ?? provider.sortedPeriods.first ?? provider.minPeriod
                self.updateExternalInstallment(provider: provider, period: period)
                tableView.reloadData()
            }
            cell.onPeriodChanged = { [weak self, weak tableView] period in
                guard let self else { return }
                self.sharedPeriod = period
                if self.selectedExternalProvider?.alias == provider.alias {
                    self.updateExternalInstallment(provider: provider, period: period)
                } else if let activeProvider = self.selectedExternalProvider,
                          activeProvider.sortedPeriods.contains(period) {
                    self.updateExternalInstallment(provider: activeProvider, period: period)
                }
                let sectionsToReload = [Section.credits, .externalProviders].compactMap { self.sections.firstIndex(of: $0) }
                tableView?.reloadSections(IndexSet(sectionsToReload), with: .none)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch sections[indexPath.section] {
        case .credits:
            guard indexPath.row < creditTypes.count else { return }
            selectedExternalProvider = nil
            selectedExternalPeriod = 0
            creditOrder.externalInstalment = nil
            creditOrder.creditType = creditTypes[indexPath.row]
            tableView.reloadData()
        case .externalProviders:
            break
        default:
            break
        }
    }
  
}
