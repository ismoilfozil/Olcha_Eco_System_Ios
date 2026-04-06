//
//  ProductListHeader+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/07/22.
//

import UIKit
import OlchaUI
extension ProductsListHeader: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == filterCollection {
            return headerSections.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollection {
            let section = headerSections[section]
            
            switch section {
            case .category:
                return (filters?.category == nil) ? 0 : 1
            case .price:
                return 1
            case .manufacturer:
                return (filters?.manufacturers.isEmpty ?? true) ? 0 : 1
            case .feature:
                return (filters?.features.count ?? 0)
            }
        } else {
            return (filters?.tags.count ?? 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == filterCollection {
            let section = headerSections[indexPath.section]
            let cell = collectionView.dequeue(HeaderFilterItem.self, for: indexPath)
            
            switch section {
            case .category:
                var title = "categories".localized()
                
                if (filters?.category?.getName() ?? "") != "" {
                    title += ": " + (filters?.category?.getName() ?? "")
                }
                
                cell.setup(title: title)
                cell.checkStatus(filters?.category != nil)
                
                break
            case .price:
                let title = "price".localized()
                
                cell.setup(title: title)
                cell.checkStatus( viewModel.checkPriceCellStatus(filters: filters) )
                cell.filter.clicked { [weak self] in
                    guard let self = self else { return }
                    self.cancelPrice()
                }
                break
            case .manufacturer:
                cell.setup(title: "brands".localized())
                cell.checkStatus( viewModel.checkManufacturersCellStatus(filters: filters) )
                cell.filter.clicked { [weak self] in
                    guard let self = self else { return }
                    self.cancelManufacturer()
                }
                break
            case .feature:
                
                cell.setup(data: filters?.features[indexPath.item])
                cell.checkStatus(
                    viewModel.checkFeaturCellStatus(
                        filters: filters,
                        at: indexPath.item)
                )
                
                cell.filter.clicked { [weak self] in
                    guard let self = self else { return }
                    self.cancelFeature(index: indexPath.item)
                }
                
                break
            }
            
            return cell
        } else {
            let cell = collectionView.dequeue(FilterItem.self, for: indexPath)
            cell.setup(with: filters?.tags[indexPath.item].name ?? " - ")
            cell.enabled = true
            cell.isChosen = filters?.tags[indexPath.item].isSelected ?? false
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollection {
            let section = headerSections[indexPath.section]
            switch section {
            case .category:
                filters?.observers.openCategoryFilter.send(true)
            case .price:
                filters?.observers.openPriceFilter.send(true)
            case .manufacturer:
                filters?.observers.openManufacturersFilter.send(true)
            case .feature:
                filters?.observers.openFeatureFilter.send(indexPath.item)
            }
        } else {
            if (filters?.tags[indexPath.item].isEnabled ?? true) {
                
                filters?.tags[indexPath.item].isSelected.optionalToggle()
                filters?.observers.tagSelected.send(true)

            }
        }
        
//        filterCollection.reloadData()
//        tagCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            .init(width: 100, height: 32)
    }
    
    private func cancelFeature(index: Int) {
        viewModel.cancelFilters(filters: filters, at: index)
        filterCollection.reloadData()
        filters?.observers.filterSelected.send(true)
    }
    
    private func cancelManufacturer() {
        guard filters?.staticManufacturer == nil else { return }
        viewModel.cancelManufacturers(filters: filters)
        filterCollection.reloadData()
        filters?.observers.manufacturerSelected.send(true)
    }
    
    private func cancelCategory() {
        guard filters?.staticManufacturer != nil else { return }
        filters?.category = nil
        filterCollection.reloadData()
        filters?.observers.loadProductsObserver.send(true)
    }
    
    private func cancelPrice() {
        filters?.filterPrice = ProductListPrice()
        filterCollection.reloadData()
        filters?.observers.loadProductsObserver.send(true)
    }
    
}

