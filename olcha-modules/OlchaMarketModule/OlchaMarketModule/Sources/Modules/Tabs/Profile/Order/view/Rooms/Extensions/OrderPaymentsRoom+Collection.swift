//
//  OrderPaymentsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/10/22.
//


import UIKit
import OlchaUI
extension OrderPaymentsRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .balance:
            return (balance == nil) ? 0 : 1
        case .card:
            return bankCards.count
        case .payments:
            return payments.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section] {
        case .balance:
            let cell = collectionView.dequeue(PaymentTitleItem.self, for: indexPath)
            cell.rightButtonEnabled = true
            cell.setup(title: "Olcha Balans", subtitle: "your_balance".localized() + " " + (balance?.getAmount().originalPrice ?? ""))
            cell.isChosen = (observer?.selectedPayment == .balance)
            cell.rightButton.clicked { [weak self] in
                guard let self = self else { return }
                observer?.balanceFill.send()
            }
            return cell
        case .card:
            let cell = collectionView.dequeue(PaymentTitleItem.self, for: indexPath)
            cell.rightButtonEnabled = false
            cell.setup(title: bankCards[indexPath.item].full_name ?? " - ",
                       subtitle: bankCards[indexPath.item].card_number?.hideCardNumber ?? "")
            
            
            
            switch observer?.selectedPayment {
            case .card(let card):
                cell.isChosen = (bankCards[indexPath.item] == card)
                break
            default:
                cell.isChosen = false
                break
            }
            return cell
        case .payments:
            let cell = collectionView.dequeue(PaymentIconItem.self, for: indexPath)
            cell.setup(with: payments[indexPath.item])
            
            switch observer?.selectedPayment {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case .payments:
            return .init(width: (collectionView.frame.width / 2 - 4), height: paymentSystemHeight)
        default:
            return .init(width: collectionView.frame.width, height: paymentHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .balance:
            observer?.selectedPayment = .balance
            observer?.isSelected.send(true)
            break
        case .card:
            observer?.selectedPayment = .card(card: bankCards[indexPath.item])
            observer?.isSelected.send(true)
            break
        case .payments:
            observer?.selectedPayment = .payment(payment: payments[indexPath.item])
            observer?.isSelected.send(true)
            break
        }
    }
}
