////
////  BrandProductsPage+Networking.swift
////  NewOlcha
////
////  Created by Elbek Khasanov on 05/09/22.
////
//
//import Foundation
//extension BrandProductsPage: ButtonMenusDelegate {
//    func loadMore() {
//        filters.paging.isLoading = true
//        loadProducts()
//    }
//    
//    func loadNewly() {
//        filters.paging.isLoading = true
//        products.removeAll()
//        
//        filters.paging.total = 1
//        filters.paging.current = 1
//        
//        loadProducts()
//    }
//    
//    func loadProducts() {
//        viewModel.loadCategoryProducts(filters: filters)
//    }
//    
//    func checkPaginator(index: Int) {
//        if index == (products.count - 3) {
//            if !filters.paging.isLoading {
//                filters.paging.current = filters.paging.current + 1
//                if filters.paging.current <= filters.paging.total {
//                    loadMore()
//                }
//            }
//        }
//    }
//    
//    func selected(sort: SortItem) {
//        guard let sort = sort as? ProductsSortItem else { return }
//        filters.selectedSort = sort
//        hideMenus()
//        loadNewly()
//    }
//}
