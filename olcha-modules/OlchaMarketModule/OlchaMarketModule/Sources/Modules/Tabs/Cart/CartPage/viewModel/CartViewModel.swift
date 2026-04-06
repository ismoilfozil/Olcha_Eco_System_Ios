//
//  CartViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/09/22.
//

import Foundation
import Combine
import OlchaAuth
import OlchaUI
import OlchaCore
public class CartViewModel: OldBaseViewModel {
    
    public static let shared = CartViewModel()
    
    @Published var favouriteProducts: ProductsData?
    @Published var favouriteProductsError: Bool = false
    @Published var favouriteChangedID: Int?
    
    
    let favouriteLoading = CurrentValueSubject<Bool, Never>(false)
    let favouriteAdded = PassthroughSubject<Bool, Never>()
    let favouritesReload = PassthroughSubject<Bool, Never>()
    
    let cartItemChanged = PassthroughSubject<CartItem?, Never>()
    
    var favouritesAuthError : (() -> Void)?
    
    @Published var cartItems: [CartItem] = []
    @Published public var cartCount = 0
    @Published var favouritesCount = 0
    @Published var deletedCart = false
    
    let loadCartItems = PassthroughSubject<Bool, Never>()
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
}

//MARK: -  Favourites
extension CartViewModel {
    public func loadFavourites(page: Int) {
        let api: CartAPI = .favourites(page: page)
        
        self.startRequesting(api: api, indicator: favouriteLoading) { [weak self] (data: ProductsData?) in
            guard let self = self else { return }
            self.favouriteProducts = data
            self.favouritesCount = data?.paginator?.total ?? 0
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
            self.favouriteProductsError = true
        }
    }
    
    public func addFavourites(product: ProductModel?, isAdding: Bool) {
        guard let productID = product?.id else { return }
        let api: CartAPI = .addFavourites(productID: productID)
        self.favouriteChangedID = productID
        
        if isAdding {
            MetricEvents.shared.addToFavourites(product)
            
            CartViewModel.shared.favouriteAdded.send(true)
            favouritesCount += 1
        } else {
            favouritesCount -= 1
        }
        
        self.startRequesting(api: api, indicator: favouriteLoading) { [weak self] (data: FavoriteAddModel?) in
            guard let self = self else { return }
            OlchaGlobalDefaults.favorite_key = data?.favorite_key
        }
    }
    
    public func mergeFavorites() {
        let api: CartAPI = .mergeFavourites
        self.startRequesting(api: api) { [weak self] (data: EmptyData?) in
            guard let self = self else { return }
            OlchaGlobalDefaults.favorite_key = nil
            loadFavourites(page: 1)
        }
    }
}

//MARK: -  Cart
extension CartViewModel {
    public func loadCart() {
        let api: CartAPI = .getCart
        ///cartga qo'shilganida bir vaqtni o'zida ulgurmay qovotti

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.startRequesting(api: api, isCancellable: true) { (data: CartData?) in
                self.cartItems = data?.cart?.cart_items ?? []
                self.cartCount = self.cartItems.count
                OlchaGlobalDefaults.cart_key = data?.cart?.key
            }
        }
    }
    
    func cartChangeCount(productID: Int?,
                         storeID: Int?,
                         quantity: Int?,
                         addQuantity: Int = 1,
                         type: CountType,
                         loadStoresProducts: Bool = true,
                         completion: (() -> Void)? = nil) {
        
        guard let productID = productID, let storeID = storeID else { return }
        
        if let quantity = quantity {
            let cartItem = CartItem(product_id: productID,
                                    store_id: storeID,
                                    quantity: quantity)
            cartItemChanged.send(cartItem)
            changeCartCount(item: cartItem, type: type)
        }
        
        let addCartItem = CartItem(product_id: productID,
                                   store_id: storeID,
                                   quantity: addQuantity)
        switch type {
        case .plus:
            plusCart(item: addCartItem, loadStoresProducts: loadStoresProducts, completion: completion)
            break
        case .minus:
            minusCart(item: addCartItem, loadStoresProducts: loadStoresProducts, completion: completion)
            break
        default: break
        }
    }
    
    func deleteCart(items: [CartItem]) {
        guard !items.isEmpty else { return }
        
        cartCount -= items.count
        let api: CartAPI = .deleteCart(model: .init(cart_items: items))
        
        startRequesting(api: api) { [weak self] (data: EmptyData?) in
            guard let self = self else { return }
//            loadCartItems.send(true)
            
            for item in items {
                let newItem = item
                newItem.quantity = 0
                cartItemChanged.send(newItem)
            }
        }
    }
    
    func deleteCartLocally(items: [CartItem]) {
        guard !items.isEmpty else { return }
        
        cartCount -= items.count
        
        for item in items {
            let newItem = item
            newItem.quantity = 0
            cartItemChanged.send(newItem)
        }
    }
    
    private func plusCart(item: CartItem, loadStoresProducts: Bool = true, completion: (() -> Void)? = nil) {
        let api: CartAPI = .plusCart(model: .init(cart_items: [item]))
        
        self.startRequesting(api: api) { [weak self] (data: EmptyData?) in
            guard let self = self, loadStoresProducts else { return }
            self.loadCartItems.send(true)
            completion?()
        } onError: { _ in }
    }
    
    private func minusCart(item: CartItem, loadStoresProducts: Bool = true, completion: (() -> Void)? = nil) {
        let api: CartAPI = .minusCart(model: .init(cart_items: [item]))
        
        self.startRequesting(api: api) { [weak self] (data: EmptyData?) in
            guard let self = self, loadStoresProducts else { return }
            self.loadCartItems.send(true)
            completion?()
        } onError: { _ in }
    }
    
    private func changeCartCount(item: CartItem, type: CountType) {
        switch type {
        case .plus:
            if item.quantity == 1 {
                cartCount += 1
            }
            break
        case .minus:
            if item.quantity == 0 {
                cartCount -= 1
            }
            break
        default: break
        }
    }
    
}
