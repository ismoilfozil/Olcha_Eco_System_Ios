//
//  LetterAllBrandsPage+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/08/22.
//

import UIKit
extension LetterAllBrandsPage: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(BrandItemCell.self, for: indexPath)
        cell.setup(with: brands[indexPath.item].main_image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width / 3, height: 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMore(index: indexPath.item)
    }
              
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.pushBrandProducts(
            filters: ProductListFilters().setStaticManufacturer(brands[indexPath.item])
        )
    }
}
