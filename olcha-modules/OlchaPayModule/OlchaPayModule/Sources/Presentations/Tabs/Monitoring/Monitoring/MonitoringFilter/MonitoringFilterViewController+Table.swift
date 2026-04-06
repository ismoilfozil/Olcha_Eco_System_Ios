//
//  MonitoringModalViewController+Table.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI
extension MonitoringFilterViewController: TableDelegates {
    
    public enum Section {
        case categories
        case cards
        
        var headerTitle: String {
            switch self {
            case .categories:
                return "categories".localized()
            case .cards:
                return "cards".localized()
            }
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
            case .categories:
                return categories.count
            case .cards:
                return cardTypes.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SelectableRoom.self, for: indexPath)
        switch sections[indexPath.section] {
        case .categories:
            cell.setup(with: categories[indexPath.row].getTitle())
            cell.isChosen = (categories[indexPath.row].id == filters.categoryID)
            break
        case .cards:
            cell.setup(with: cardTypes[indexPath.row].title)
            cell.isChosen = (cardTypes[indexPath.row].alias == filters.cardType)
            break
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch sections[indexPath.section] {
        case .categories:
            
            if filters.categoryID == categories[indexPath.row].id {
                filters.categoryID = nil
            } else {
                filters.categoryID = categories[indexPath.row].id
            }
            
            break
        case .cards:
            if filters.cardType == cardTypes[indexPath.row].alias {
                filters.cardType = nil
            } else {
                filters.cardType = cardTypes[indexPath.row].alias
            }
            break
        }
        
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeue(MonitoringFilterHeaderRoom.self)
        switch sections[section] {
        case .categories:
            if categories.isEmpty {
                return .init(frame: .zero)
            }
        case .cards:
            if cardTypes.isEmpty {
                return .init(frame: .zero)
            }
            break
        }
        header.setup(title: sections[section].headerTitle)
        return header
    }
    
}
