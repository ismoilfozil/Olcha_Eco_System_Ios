//
//  CartPage+Credit.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/10/22.
//

import UIKit
extension UserCartPage {
    func presentCreditModalPage() {
        coordinator?.presentCreditBuy(products: observers.products, balanceViewModel: viewModels.balance, observers: observers)
    }
    
    func presentReceiverModalPage() {
        coordinator?.presentReceiverModalPage(observers: observers)
    }
    
    func checkPaymentType() {
        guard observers.selectedBuyType == .credit else { return }
        creditWithoutInitialFee()
    }
    
    func creditWithoutInitialFee() {
        if observers.selectedBuyType == .credit && observers.credit?.creditDatas[observers.credit?.creditType ?? .olcha]?.first_fee_sum == 0 && observers.credit?.creditType != .anorbank {
            checkRegionForPayment()
        }
    }
}
