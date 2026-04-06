//
//  SearchPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/10/22.
//

import UIKit
import OlchaUI
extension SearchPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .history:
            return (textField().text != "") ? 0 : (OlchaGlobalDefaults.search.histories?.count ?? 0)
        case .category:
            return categories.count
        case .brand:
            return brands.count
        case .products:
            return products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        
        switch section {
            case .history:
                let cell = tableView.dequeue(SearchTextRoom.self, for: indexPath)
            cell.setup(title: OlchaGlobalDefaults.search.histories?[indexPath.row],
                           type: .history)
            cell.rightIcon.clicked {
                OlchaGlobalDefaults.search.remove(index: indexPath.row)
                tableView.reloadData()
            }
                return cell
            case .category:
                let cell = tableView.dequeue(SearchTextRoom.self, for: indexPath)
                cell.setup(title: categories[indexPath.row].getName(),
                           type: .title)
                return cell
            case .brand:
                let cell = tableView.dequeue(SearchTextRoom.self, for: indexPath)
                cell.setup(title: brands[indexPath.row].getName(),
                           subtitle: "brand".localized(),
                           type: .title)
                return cell
            case .products:
                let cell = tableView.dequeue(SearchImageRoom.self, for: indexPath)
                cell.setup(product: products[indexPath.row])
                return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch sections[indexPath.section] {
        case .history:
            viewModel.search(text: OlchaGlobalDefaults.search.histories?[indexPath.row],
                             forcedSearch: true)
            textField().text = OlchaGlobalDefaults.search.histories?[indexPath.row]
            break
        case .category:
            coordinator?.pushProductList(category: categories[indexPath.row])
            break
        case .brand:
            coordinator?.pushBrandProducts(filters: ProductListFilters().setStaticManufacturer(brands[indexPath.row]))
            break
        case .products:
            coordinator?.pushProduct(product: products[indexPath.row])
            break
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textField().resignFirstResponder()
    }
}
