//
//  PartnerCategoriesRoom+Collection.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 19/06/23.
//

import UIKit
import OlchaUI
extension PartnerCategoriesRoom: CollectionDelegates {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PartnerCategoryItem.self, for: indexPath)
        if categories.isGreater(indexPath) {
            cell.setup(title: categories[indexPath.item].name)
        }
        return cell
    }
}
