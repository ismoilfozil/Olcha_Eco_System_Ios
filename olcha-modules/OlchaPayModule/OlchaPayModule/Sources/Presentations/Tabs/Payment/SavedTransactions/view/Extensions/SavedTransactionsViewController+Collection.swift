//
//  SavedTransactionsViewController+Collection.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/04/23.
//

import UIKit
import OlchaUI
extension SavedTransactionsViewController: CollectionDelegates {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return transactions.count
        default:
            return paging.footerLoadingCount()
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeue(SavedTransactionItem.self, for: indexPath)
            
            let model = transactions[indexPath.item]
            
            cell.setup(data: model)
            cell.withBorder = true
            cell.menuButton.isHidden = false
            cell.menuButton.clicked {
                cell.dropDown.show()
            }
            
            cell.editTransaction = { [weak self] in
                guard let self = self else { return }
                if self.transactions.isGreater(indexPath) {
                    self.editTransaction(model: self.transactions[indexPath.item])
                }
            }
            
            cell.deleteTransaction = { [weak self] in
                guard let self = self else { return }
                self.deleteTransaction(at: indexPath)
            }
                                                   
            return cell
        default:
            let cell = collectionView.dequeue(FooterCollectionItem.self, for: indexPath)
            cell.responder.configureIndicator()
            return cell
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return .init(width: (collectionView.frame.width / 3),
                         height: collectionView.frame.width / 3)
        default:
            return .init(width: collectionView.frame.width,
                         height: 50)
        }
        
    }
}
