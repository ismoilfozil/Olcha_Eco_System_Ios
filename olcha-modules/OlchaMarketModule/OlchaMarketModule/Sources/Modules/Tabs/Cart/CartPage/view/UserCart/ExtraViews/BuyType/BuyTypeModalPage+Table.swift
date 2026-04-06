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
        case graph
    }
}
extension BuyTypeModalPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .buyTypes:
            return typesCount
        case .calculator:
            return (selectedBuyType == .credit) ? 1 : 0
        case .graph:
            return (selectedBuyType == .credit) ? 1 : 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .buyTypes:
            let sectionType = types[indexPath.row]
            switch sectionType {
            case .cash:
                let cell = tableView.dequeue(BuyTypeSelectRoom.self, for: indexPath)
                cell.separator.isHidden = false
                cell.isChosen = (selectedBuyType == sectionType)
                cell.setupState(isEnabled: true)
                cell.button.clicked { [weak self] in
                    guard let self else { return }
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
            cell.creditOrder = creditOrder
            cell.setup(with: observers?.products ?? [])
            cell.setupTempData()
            return cell
        case .graph:
            let cell = tableView.dequeue(CreditGraphRoom.self, for: indexPath)
            cell.creditOrder = creditOrder
            cell.products = observers?.products ?? []
            cell.graphObserver = graphObserver
            cell.setup()
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
