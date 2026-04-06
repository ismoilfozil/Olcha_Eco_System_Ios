//
//  ProductCell+Collection.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 11/10/23.
//

import UIKit
import OlchaUI

extension ProductCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ImageItem.self, for: indexPath)
        if images.isGreater(indexPath) {
            cell.setup(isWhite: product?.is_white ?? true,
                       urlString: images[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        productHelper?.pushProduct.send(product)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imagesPageControl.setupSizedProgress(with: scrollView)
    }
}

extension ProductCell {
    func listSeparators(indexPath: IndexPath) {
        if indexPath.item % 2 == 0 {
            separatorState(positions: [.top, .bottom, .right])
        } else {
            separatorState(positions: [.top, .bottom, .left])
        }
    }
}
