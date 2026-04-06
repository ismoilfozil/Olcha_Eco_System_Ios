//
//  CatalogBannersRoom+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/08/22.
//

import UIKit
extension CatalogBannersRoom: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = banners.count
        
        self.paginator.numberOfPages = count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(BannerItem.self, for: indexPath)
        cell.layoutIfNeeded()
        cell.setup(with: banners[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushSliderObserver?.send(banners[indexPath.item])
    }
    
}
