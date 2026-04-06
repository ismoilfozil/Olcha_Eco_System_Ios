//
//  CatalogListPage+TableView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/07/22.
//


import UIKit
import Combine


final class CatalogListPageProvider: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    
    weak var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.registerClass(forCell: CatalogRoom.self)
            tableView?.estimatedRowHeight = UITableView.automaticDimension
            tableView?.separatorStyle = .none
            tableView?.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        }
    }
    
    var catalogStack: [CategoryModel] = [] {
        didSet {
            reloadObserver?.send(true)
        }
    }
    
    var reloadObserver: CurrentValueSubject<Bool, Never>?
    
    var selectedCategory: CategoryModel?

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return catalogStack.count
        } else {
            return (catalogStack.last?.children?.count ?? 0)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CatalogRoom.self, for: indexPath)
        if indexPath.section == 0 {
            let category = catalogStack[indexPath.row]
            cell.setup(model: category,
                       step: indexPath.row,
                       isSelectedItem: (category == selectedCategory))
        } else {
            let category = catalogStack.last?.children?[indexPath.row]
            cell.setup(model: category,
                       step: catalogStack.count,
                       isSelectedItem: (category == selectedCategory))
        }
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            catalogStack = Array(catalogStack[0...indexPath.row])
            selectedCategory = catalogStack.last
        } else {
            if let category = catalogStack.last?.children?[indexPath.row] {
                selectedCategory = category
                if !(category.children?.isEmpty ?? true) {
                    catalogStack.append(category)
                }
            }
        }
        
        reloadObserver?.send(true)
    }
}
