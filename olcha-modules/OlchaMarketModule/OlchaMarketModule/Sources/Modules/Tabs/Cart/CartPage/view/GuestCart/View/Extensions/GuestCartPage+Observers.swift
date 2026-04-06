//
//  GuestCartPage+Observers.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 30/01/24.
//

import Foundation
extension GuestCartPage {
    func setupCartObservers() {
        CartViewModel
            .shared
            .loadCartItems
            .sink { [weak self] canLoad in
                guard let self, canLoad else { return }

                CartViewModel.shared.loadCart()
                placeholderIndicatorWorker()
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .$cartItems
            .sink { [weak self] items in
                guard let self = self else { return }
                viewModels.checkout.loadCartProducts(cartItems: items)
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .cartItemChanged
            .sink { [weak self] item in
                guard let self else { return }
                tableReloader()
            }.store(in: &bag)
        
        handle(viewModels.checkout.$cartProducts,
               success: { [weak self] data in
            guard let self else { return }
            observers.appendProducts(data ?? []) {
                self.observers.action.productsUpdated.send()
            }
        },
               loading: { [weak self] isLoading in
            guard let self else { return }
            setProductsSkeletonAnimating(isLoading)
            if !isLoading {
                placeholder.setupIndicator(isLoading: false)
            }
        })
    }
    
    func setupFactoryObservers() {
        observers.action.productsUpdated.sink { [weak self] in
            guard let self else { return }
            tableReloader()
        }.store(in: &bag)
        
        observers
            .navigation
            .productHelper
            .pushProduct.sink { [weak self] data in
                guard let self else { return }
                coordinator?.pushProductPage(product: data)
            }.store(in: &bag)
    }
    
    func setupActionObservers() {
        calculationButton.button.clicked { [weak self] in
            guard let self else { return }
            coordinator?.pushAuth {}
        }
        
        placeholderButton { [weak self] in
            guard let self = self else { return }
            popToMainTab(mainTabIndex: OlchaTab.home)
        }
    }
    
    func placeholderIndicatorWorker() {
        if observers.products.isEmpty {
            placeholder.setupIndicator(isLoading: true)
        }
    }
    
}

extension GuestCartPage {
    func setupProducts() {
        calculationButton.setup(products: observers.products)
    }
}
