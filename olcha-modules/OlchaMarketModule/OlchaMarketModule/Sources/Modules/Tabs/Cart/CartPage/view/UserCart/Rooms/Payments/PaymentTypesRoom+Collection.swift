//
//  PaymentTypesRoom+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/10/22.
//

import UIKit
import OlchaUI
extension PaymentTypesRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        payments.count + paymentSystems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if isPayments(indexPath) {
            let cell = collectionView.dequeue(PaymentTitleItem.self, for: indexPath)
            let item = payments[paymentIndex(indexPath)]

            cell.setup(title: item.getName(),
                       subtitle: item.getDescription())
            
            cell.isChosen = (selectedPayment == item)
            return cell
        } else {
            let cell = collectionView.dequeue(PaymentIconItem.self, for: indexPath)
            let item = paymentSystems[paymentSystemsIndex(indexPath)]
            cell.setup(with: item)
            cell.isChosen = (selectedPayment == item)
            cell.setup(amount: item.balance?.getAmount())
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isPayments(indexPath) {
            return .init(width: collectionView.frame.width, height: paymentHeight)
        } else {
            return .init(width: (collectionView.frame.width / 2 - 4), height: paymentSystemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isPayments(indexPath) {
            observers?.selectedPayment = payments[paymentIndex(indexPath)]
        } else {
            observers?.selectedPayment = paymentSystems[paymentSystemsIndex(indexPath)]
        }
        observers?.action.paymentSelected.send()
    }
    
    private func isPayments(_ indexPath: IndexPath) -> Bool {
        (indexPath.item) < payments.count
    }
    
    private func paymentIndex(_ indexPath: IndexPath) -> Int {
        indexPath.item
    }
    
    private func paymentSystemsIndex(_ indexPath: IndexPath) -> Int {
        indexPath.item - payments.count
    }
}
