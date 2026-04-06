//
//  FeatureModalPage+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import OlchaUI
extension CollectionFeaturesView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch self.section {
            case .tags:
                return self.filters?.tags.count ?? 0
            case .brands:
                return self.filters?.manufacturers.count ?? 0
            case .features(let index):
                return self.filters?.features[index].values?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch self.section {
        case .tags:
            let cell = collectionView.dequeue(FilterItem.self, for: indexPath)
            let value = filters?.tags[indexPath.item]
            
            cell.setup(with: filters?.tags[indexPath.item].name ?? "")
            
            cell.isChosen = (value?.isSelected ?? false)
            cell.enabled = (value?.isEnabled ?? true)
            return cell
        case .brands:
            let cell = collectionView.dequeue(FilterItem.self, for: indexPath)
            let value = filters?.manufacturers[indexPath.item]
            
            cell.setup(with: value?.getName() ?? "")
            
            cell.isChosen = (value?.isSelected ?? false)
            cell.enabled = (value?.isEnabled ?? true)
            return cell
        case .features(let index):
            let type = filters?.features[index].getFeatureType()
            switch type {
            case .colour:
                let cell = collectionView.dequeue(FilterColorItem.self, for: indexPath)
                let value = filters?.features[index].values?[indexPath.item]
                
                cell.setup(with: value?.colour_code ?? "")
                
                cell.isChosen = (value?.isSelected ?? false)
                cell.enabled = (value?.isEnabled ?? true)
                return cell
            default:
                let cell = collectionView.dequeue(FilterItem.self, for: indexPath)
                let value = filters?.features[index].values?[indexPath.item]
                
                cell.setup(with: value?.getName() ?? "")
                
                cell.isChosen = (value?.isSelected ?? false)
                cell.enabled = (value?.isEnabled ?? true)
                return cell
            }
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard var cell = collectionView.cellForItem(at: indexPath) as? ChoosableCell else { return }
        
        switch self.section {
        case .tags:
            let item = filters?.tags[indexPath.item]
            if (item?.isEnabled ?? true) {
               
                
                filters?.tags[indexPath.item].isSelected.optionalToggle()
                
                cell.isChosen = filters?.tags[indexPath.item].isSelected ?? false
                
                filters?.observers.tagSelected.send(true)
                
            }
            break
        case .brands:
            let item = filters?.manufacturers[indexPath.item]
            if (item?.isEnabled ?? true) {
                
                
                filters?.manufacturers[indexPath.item].isSelected.optionalToggle()
                cell.isChosen = filters?.manufacturers[indexPath.item].isSelected ?? false
                
                filters?.observers.manufacturerSelected.send(true)
                
            }
            break
        case .features(let index):
            let item = filters?.features[index].values?[indexPath.item]
            if (item?.isEnabled ?? true) {
                
                filters?.features[index].values?[indexPath.item].isSelected.optionalToggle()
                cell.isChosen = filters?.features[index].values?[indexPath.item].isSelected ?? false
                
                filters?.observers.filterSelected.send(true)
                
            }
            break
        }
        
    }
}
