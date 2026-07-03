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
        self.collection.reloadSections(.init(integer: Section.footer.rawValue))
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
        let threshold = max(self.products.count - self.filters.paging.per_page / 2, 0)
        guard index >= threshold,
              !self.filters.paging.isLoading,
              self.filters.paging.current < self.filters.paging.total else { return }

        self.filters.paging.current += 1
        loadMore()
    }

    func checkPaginator(scrollView: UIScrollView) {
        let bottomOffset = scrollView.contentOffset.y + scrollView.bounds.height
        let triggerOffset = scrollView.contentSize.height - 400

        guard bottomOffset >= triggerOffset,
              !self.filters.paging.isLoading,
              self.filters.paging.current < self.filters.paging.total else { return }

        self.filters.paging.current += 1
        loadMore()
    }
    
    public func selected(sort: SortItem) {
        guard let sort = sort as? ProductsSortItem else { return }
        self.filters.selectedSort = sort
        self.hideMenus()
        self.loadNewly()
    }
}
