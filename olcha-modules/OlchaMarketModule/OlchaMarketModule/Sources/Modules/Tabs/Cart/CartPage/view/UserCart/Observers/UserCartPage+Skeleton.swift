//
//  CartPage+Skeleton.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 19/01/24.
//

import Foundation
//MARK: - Skeletons
extension UserCartPage {
    func setProductsSkeletonAnimating(_ isLoading: Bool) {
        if observers.products.isEmpty {
            observers.skeleton.products.isAnimating = isLoading
        } else {
            observers.skeleton.products.isAnimating = false
        }
        if !isLoading {
            placeholder.setupIndicator(isLoading: isLoading)
        }
        setBuyTypesSkeletonAnimating(isLoading)
        table.reloadData()
    }
    
    func setLocationsSkeletonAnimating(_ isLoading: Bool) {
        if observers.locations.isEmpty {
            observers.skeleton.locations.isAnimating = isLoading
        } else {
            observers.skeleton.locations.isAnimating = false
        }
        table.reloadData()
    }
    
    func setBuyTypesSkeletonAnimating(_ isLoading: Bool) {
        if observers.products.isEmpty {
            observers.skeleton.buyTypes.isAnimating = isLoading
        } else {
            observers.skeleton.buyTypes.isAnimating = false
        }
    }
}
