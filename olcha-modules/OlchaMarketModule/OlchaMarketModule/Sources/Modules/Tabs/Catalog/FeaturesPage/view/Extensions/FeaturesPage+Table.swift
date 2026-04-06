//
//  FeaturesPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
extension FeaturesPage: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .price:
            return 1
        case .tags:
            return (mockFilters?.tags.isEmpty ?? true) ? 0 : 1
        case .brands:
            return (mockFilters?.manufacturers.isEmpty ?? true) ? 0 : 1
        case .features:
            return mockFilters?.features.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .price:
            let cell = tableView.dequeue(PriceFilterItem.self, for: indexPath)
            cell.setup(with: mockFilters)
            return cell
        case .tags:
            
            let cell = tableView.dequeue(CollectionFilterItem.self, for: indexPath)
            cell.setup(with: mockFilters, section: .tags)
            cell.featuresView.featuresShowButton.clicked { [weak self] in
                guard let self = self else { return }
                self.showAllTags()
            }
            return cell
        case .brands:
            
            let cell = tableView.dequeue(CollectionFilterItem.self, for: indexPath)
            cell.featuresView.delegate = self
            cell.setup(with: mockFilters, section: .brands)
            cell.featuresView.featuresShowButton.clicked { [weak self] in
                guard let self = self else { return }
                self.showAllManufacturers()
            }
            return cell
        case .features:
            
            let cell = tableView.dequeue(CollectionFilterItem.self, for: indexPath)
            cell.featuresView.delegate = self
            cell.setup(with: mockFilters, section: .features(index: indexPath.row))
            cell.featuresView.featuresShowButton.clicked { [weak self] in
                guard let self = self else { return }
                self.showAllFeatures(index: indexPath.row)
                
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func showAllFeatures(index: Int) {
        coordinator?.pushAllFeaturesList(with: mockFilters, index: index)
    }
    
    
    func showAllManufacturers() {
        coordinator?.pushAllManufacturersList(with: mockFilters)
    }
    
    func showAllTags() {
        coordinator?.pushAllTagsList(with: mockFilters)
    }
    
}

extension FeaturesPage: FeaturesPageDelegate {
    func reloadTable() {
        table.reloadData()
    }
}

protocol FeaturesPageDelegate: AnyObject {
    func reloadTable()
}
