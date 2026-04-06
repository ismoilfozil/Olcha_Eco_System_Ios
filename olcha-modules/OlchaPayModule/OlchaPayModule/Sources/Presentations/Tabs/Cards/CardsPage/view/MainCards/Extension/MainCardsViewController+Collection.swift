//
//  MainCardsView+Collection.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/02/23.
//

import UIKit
import OlchaUI
extension MainCardsViewController: CollectionDelegates {
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        paginator.numberOfPages = cards.count + 1
        return cards.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isAddCardItem(indexPath) {
            let cell = collectionView.dequeue(AddCardItem.self, for: indexPath)
            cell.setup()
            return cell
        } else {
            
            let cell = collectionView.dequeue(MainCardItem.self, for: indexPath)
            if cards.isGreater(indexPath) {
                cell.setup(card: cards[indexPath.item])
            }
            return cell
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isAddCardItem(indexPath) {
            addCardObserver?()
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collection,
           let page = layout.currentCenteredPage {
            paginator.currentPage = page
            if cards.isGreater(page) {
                currentIndex = page
            } else {
                currentIndex = nil
            }
        }
    }
    
    private func isAddCardItem(_ indexPath: IndexPath) -> Bool {
        indexPath.item == cards.count
    }
}
