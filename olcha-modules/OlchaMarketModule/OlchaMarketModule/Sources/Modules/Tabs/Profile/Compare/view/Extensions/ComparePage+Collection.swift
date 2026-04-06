//
//  CompareCollectionRoom+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/08/22.
//

import UIKit
import OlchaUI
extension ComparePage: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollection {
            return compareGroupModels.count
        } else {
            if let selectedIndex, compareGroupModels.isGreater(selectedIndex) {
                return compareGroupModels[selectedIndex].products.count
            } else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollection {
            let cell = collectionView.dequeue(CompareCategoryCell.self, for: indexPath)
            guard compareGroupModels.isGreater(indexPath) else { return UICollectionViewCell() }
            
            let model = compareGroupModels[indexPath.item]
            let category = model.categroy
            
            let title: String = (category?.getName() ?? "") + " " + model.products.count.string
            cell.setup(with: title)
            
            cell.isChosen = (category == selectedCategory)
            return cell
        } else {
            let cell = collectionView.dequeue(CompareProductCell.self, for: indexPath)
            cell.productHelper = productHelper
            if let selectedIndex = selectedIndex,
               compareGroupModels.isGreater(selectedIndex),
               compareGroupModels[selectedIndex].products.isGreater(indexPath)
            {
                cell.setup(with: compareGroupModels[selectedIndex].products[indexPath.row])
                cell.setup(page: indexPath.row+1, totalPage: compareGroupModels[selectedIndex].products.count)
                cell.removeButton.clicked { [weak self] in
                    guard let self,
                          compareGroupModels.isGreater(selectedIndex),
                          compareGroupModels[selectedIndex].products.isGreater(indexPath)
                    else { return }
                    self.viewModel.removeCompare(product: self.compareGroupModels[selectedIndex].products[indexPath.row])
                    self.removeItem(at: indexPath.item)
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let baseCell = cell as? BaseCollectionCell else { return }
        baseCell.cellWillAppear()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollection {
            return .init(width: 100, height: 32)
        } else {
            return collectionView.frame.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollection {
            let category = compareGroupModels[indexPath.item].categroy
            if selectedCategory != category {
                selectedCategory = category
            }
        } else {
            guard let selectedIndex = selectedIndex else { return }
            getCoordinator()?.pushProduct(product: compareGroupModels[selectedIndex].products[indexPath.item])
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != table && scrollView != categoriesCollection {
            forceLoadOptions()
        }
    }
}
