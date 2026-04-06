//
//  GuestCartPage+Skeleton.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 30/01/24.
//

import Foundation
extension GuestCartPage {
    func setProductsSkeletonAnimating(_ isLoading: Bool) {
        if observers.products.isEmpty {
            observers.skeleton.products.isAnimating = isLoading
        } else {
            observers.skeleton.products.isAnimating = false
        }
//        setBuyTypesSkeletonAnimating(isLoading)
        table.reloadData()
    }
}
