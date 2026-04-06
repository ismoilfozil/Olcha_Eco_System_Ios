//
//  DetailedCatalogListPage+Networking.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 11/08/22.
//

import Foundation
extension DetailedCatalogListPage: ButtonMenusDelegate {
    
    public func selected(sort: SortItem) {
        guard let sort = sort as? ProductsSortItem else { return }
        
        self.filters.selectedSort = sort
        self.hideMenus()
        self.getHeader(self.collection)?.selectedSortItem = sort
        self.sortProductsIndicator.send(true)
        self.loadCategoryProductsNewly()
    }
    
    func checkCategoriesPaginator(index: Int) {
        if index == (helper.loadedCategoryProducts.count - 1) {
            if !helper.categoriesPaging.isLoading {
                helper.categoriesPaging.current = helper.categoriesPaging.current + 1
                if helper.categoriesPaging.current <= helper.categoriesPaging.total {
                    loadProducts()
                }
            }
        }
    }
    
    func loadProducts() {
        guard helper.categoriesPaging.current < helper.categories.count else { return }
        
        helper.categoriesPaging.isLoading = true
        let category = helper.categories[helper.categoriesPaging.current]
        
        let filters = ProductListFilters()
        filters.category = category
        
        viewModel.loadCategoryProducts(filters: filters)
    }
    
    func loadSliders() {
        if let alias = category?.alias {
            collection.changeState(at: Section.banner.rawValue,
                                   state: .loading)
            viewModel.loadCategorySliders(alias: alias)
        }
    }
    
    func loadPopularProducts() {
        collection.changeState(at: Section.popular.rawValue,
                                    state: .loading)
        let filters = ProductListFilters()
        filters.category = category
        viewModel.loadProducts(with: .popular,
                               filters: filters)
    }
    
    func loadCategoryBrands() {
        if helper.isCategoryProductsLoaded() && !helper.brandsPaging.isFinishedPaging {
            helper.brandsPaging.current += 1
            viewModel.loadCategoryBrands()
        }
    }
    
    func loadCategoryProductsMore() {
        filters.paging.isLoading = true
        loadCategoryProducts()
    }
    
    func loadCategoryProductsNewly() {
        filters.paging.isLoading = true
        products.removeAll()
        
        filters.paging.total = 1
        filters.paging.current = 1
        
        loadCategoryProducts()
    }
    
    func loadCategoryProducts() {
        filters.category = self.category
        viewModel.loadProducts(filters: filters)
    }
    
    func checkPaginator(index: Int) {
        if index == (products.count - 3) {
            if !filters.paging.isLoading {
                filters.paging.current = filters.paging.current + 1
                if filters.paging.current <= filters.paging.total {
                    loadCategoryProductsMore()
                }
            }
        }
    }
}
