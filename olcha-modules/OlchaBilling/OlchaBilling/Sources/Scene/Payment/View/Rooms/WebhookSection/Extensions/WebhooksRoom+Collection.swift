//
//  WebhooksRoom+Collection.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 02/08/23.
//

import UIKit
import OlchaUI

extension WebhooksRoom: CollectionDelegates {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        skeleton?.getCount(webhooks.count) ?? webhooks.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(BillingPaymentItem.self, for: indexPath)
        cell.configure(skeleton: skeleton)
        if webhooks.isGreater(indexPath) {
            cell.setup(with: webhooks[indexPath.item])
            cell.isChosen = selectedPayment?.checkIdentifier(alias: webhooks[indexPath.item].alias, id: nil) ?? false
        } else {
            cell.prepareForReuse()
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 156, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard webhooks.isGreater(indexPath) else {
            return
        }
        selectObserver?(webhooks[indexPath.item])
    }
    
}
