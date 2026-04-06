//
//  CatalogSubcatsRoom+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/08/22.
//

import UIKit
import OlchaUI
extension CatalogSubcatsRoom: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(BackgroundedImage.self, for: indexPath)
        cell.setup(background: categories[indexPath.item].background_image,
                   main: categories[indexPath.item].main_image,
                   title: categories[indexPath.item].getName())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushSubcatalogObserver?.send(categories[indexPath.item])
    }
    
}
