//
//  BalasnsFillPage+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/11/22.
//
import OlchaUI
import UIKit
extension BalanceFillPage: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .card:
            return 1
        case .payments:
            return payments.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section] {
        case .card:
            let cell = collectionView.dequeue(PaymentTitleItem.self, for: indexPath)
            cell.rightButtonEnabled = true
            cell.setup(title: "from_pin_card".localized(),
                       subtitle: "payment_uzcard_humo".localized())
            
            cell.isChosen = (observer.selectedPayment == .card)
            cell.rightButtonEnabled = false
            return cell
        case .payments:
            let cell = collectionView.dequeue(PaymentIconItem.self, for: indexPath)
            cell.setup(with: payments[indexPath.item])
            
            switch observer.selectedPayment {
                case .payment(let payment):
                    cell.isChosen = (payments[indexPath.item] == payment)
                    break
                default:
                    cell.isChosen = false
                    break
            }
            
            return cell
        }
            
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case .payments:
            return .init(width: (collectionView.frame.width / 2 - 4), height: paymentSystemHeight)
        default:
            return .init(width: collectionView.frame.width, height: paymentHeight)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .card:
            observer.selectedPayment = .card
            break
        case .payments:
            observer.selectedPayment = .payment(payment: payments[indexPath.item])
            break
        }
        
        (observer.selectedPayment != .none) ? nextButton.enableButton() : nextButton.disableButton()
        
        collectionView.reloadData()
    }
}

