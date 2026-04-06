//
//  DetailedNewsViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 16/02/23.
//

import OlchaUI
import UIKit
extension DetailedNewsViewController: UICollectionViewDelegateFlowLayout {
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        news.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DetailedNewsItem.self, for: indexPath)
        if news.isGreater(indexPath) {
            cell.setup(with: news[indexPath.item])
        }
        loadMore(indexPath.item)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
 
    
}
