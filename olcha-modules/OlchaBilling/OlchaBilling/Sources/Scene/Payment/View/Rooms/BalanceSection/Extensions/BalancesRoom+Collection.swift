//
//  WebhooksRoom+Collection.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 02/08/23.
//

import UIKit
import OlchaUI

extension BalancesRoom: CollectionDelegates {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        skeleton?.getCount(balances.count) ?? balances.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(BillingPaymentItem.self, for: indexPath)
        cell.configure(skeleton: skeleton)
        if balances.isGreater(indexPath) {
            cell.setup(with: balances[indexPath.item])
            cell.isChosen = selectedPayment?.checkIdentifier(alias: balances[indexPath.item].alias, id: balances[indexPath.item].balance?.id?.int) ?? false
        } else {
//            cell.prepareForReuse()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 156, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard balances.isGreater(indexPath) else {
            return
        }
        selectObserver?(balances[indexPath.item])
    }
    
}
