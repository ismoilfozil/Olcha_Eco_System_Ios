//
//  BuyTypeModalPage+Table.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 07/02/24.
//
import OlchaUI
import UIKit
import OlchaUtils
extension BuyTypeModalPage {
    enum Section: Int {
        case buyTypes
        case calculator
        case externalProviders
    }
}
extension BuyTypeModalPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .buyTypes:         return typesCount
        case .calculator:       return (selectedBuyType == .credit) ? 1 : 0
        case .externalProviders:
            return selectedBuyType == .credit ? (checkoutViewModel?.externalProviders.count ?? 0) : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .buyTypes:
            guard indexPath.row < types.count else { return UITableViewCell() }
            let sectionType = types[indexPath.row]
            switch sectionType {
            case .cash:
                let cell = tableView.dequeue(BuyTypeSelectRoom.self, for: indexPath)
                cell.separator.isHidden = false
                cell.isChosen = (selectedBuyType == sectionType)
                cell.setupState(isEnabled: true)
                cell.button.clicked { [weak self] in
                    guard let self else { return }
                    shouldRestoreExternalProvider = false
                    selectedBuyType = sectionType
                    tableView.reloadData()
                }
                cell.setup(title: sectionType.title)
                return cell
            default:
                let cell = tableView.dequeue(BuyTypeSelectRoom.self, for: indexPath)
                cell.separator.isHidden = true
                cell.isChosen = (selectedBuyType == sectionType)
//                cell.setupState(isEnabled: checkCreditType())
                cell.setupState(isEnabled: true)
                cell.button.clicked { [weak self] in
                    guard let self else { return }
                    selectedBuyType = sectionType
                    tableView.reloadData()
                }
//                cell.setup(title: sectionType.title, subtitle: limitError())
                cell.setup(title: sectionType.title, subtitle: "")
                return cell
            }
        case .calculator:
            let cell = tableView.dequeue(OlchaCreditStoreRoom.self, for: indexPath)
            cell.observers = observers
            cell.graphObserver = graphObserver
            cell.limitBalance = balanceViewModel?.balance.value?.instalmentBalance
            cell.isReady = checkButtonState
            cell.isBestOffer = isOlchaBestOffer()
            cell.isChosen = (selectedExternalProvider == nil)
            cell.creditOrder = creditOrder
            cell.onPeriodChanged = nil
            cell.setup(with: observers?.products ?? [])
            cell.setupTempData(preferredMonth: selectedInstallmentPeriod)
            cell.onHeightChanged = { [weak tableView] in
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
            cell.onSelected = { [weak self] in
                guard let self else { return }
                shouldRestoreExternalProvider = false
                selectedExternalProvider = nil
                selectedExternalPeriod = 0
                creditOrder.externalInstalment = nil
                tableView.reloadData()
            }
            cell.onPeriodChanged = { [weak self, weak tableView] period in
                guard let self else { return }
                selectedInstallmentPeriod = period
                if let activeProvider = selectedExternalProvider,
                   activeProvider.sortedPeriods.contains(period) {
                    selectedExternalPeriod = period
                }
                tableView?.reloadData()
            }
            return cell

        case .externalProviders:
            let providers = checkoutViewModel?.externalProviders ?? []
            guard indexPath.row < providers.count else { return UITableViewCell() }
            let provider = providers[indexPath.row]
            let cell = tableView.dequeue(ExternalInstallmentStoreRoom.self, for: indexPath)
            let totalPrice = observers?.getTotalPrice() ?? 0
            let isSelected = selectedExternalProvider?.alias == provider.alias
            let initialPeriod = isSelected ? (supportedPeriod(for: provider) ?? selectedExternalPeriod) : supportedPeriod(for: provider)
            cell.setup(provider: provider, totalPrice: totalPrice, initialPeriod: initialPeriod)
            cell.isChosen = isSelected
            cell.onSelected = { [weak self] in
                guard let self else { return }
                shouldRestoreExternalProvider = false
                selectedExternalProvider = provider
                selectedExternalPeriod = supportedPeriod(for: provider) ?? provider.sortedPeriods.first ?? provider.minPeriod
                selectedInstallmentPeriod = selectedExternalPeriod
                tableView.reloadData()
            }
            cell.onPeriodChanged = { [weak self, weak tableView] period in
                guard let self else { return }
                shouldRestoreExternalProvider = false
                selectedInstallmentPeriod = period
                selectedExternalProvider = provider
                selectedExternalPeriod = period
                tableView?.reloadData()
            }
            return cell
        }
    }
    
    private func checkCreditType() -> Bool {
//        if Config.isDebug {
//            return true
//        } else {
            return observers?.isLimitActive() ?? true
//        }
    }
    
    private func limitError() -> String? {
        checkCreditType() ? nil : "limit_balance_error".localized()
    }
}
