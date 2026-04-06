//
//  ProductsListPage+Networking.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/07/22.
//

import Foundation
import Combine
import UIKit
extension ProductsListPage: ButtonMenusDelegate {
    func loadMore() {
        self.filters.paging.isLoading = true
        self.loadProducts()
    }
    
    func loadNewly() {
        self.filters.paging.isLoading = true
        self.products.removeAll()
        self.reloadCollection()
        self.filters.paging.total = 1
        self.filters.paging.current = 1
        
        self.loadProducts()
    }
    
    func loadProducts() {
        self.catalogViewModel.loadCategoryProducts(filters: self.filters)
    }
    
    func checkPaginator(index: Int) {
        if index == (self.products.count - self.filters.paging.per_page / 2) {
            if !self.filters.paging.isLoading {
                self.filters.paging.current = self.filters.paging.current + 1
                if self.filters.paging.current <= self.filters.paging.total {
                    loadMore()
                }
            }
        }
    }
    
    public func selected(sort: SortItem) {
        guard let sort = sort as? ProductsSortItem else { return }
        self.filters.selectedSort = sort
        self.hideMenus()
        self.loadNewly()
    }
}
