//
//  HomeSegmentProductsListPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 17/11/23.
//

import Foundation
import UIKit
class HomeSegmentProductsListPage: ProductsListPage {
    
    weak var observer: HomePageProductsObserver? {
        didSet {
            scrollObserver()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.isHidden = true
        hideNavigationBar()
        header?.isHidden = true
        filterButton.isHidden = true
        
        
        collection.contentInset = .init(top: 32, left: 0, bottom: 0, right: 0)
        collection.showsVerticalScrollIndicator = false
        withPlaceholder = false
    }
    
    private func scrollObserver() {
        observer?.scrollObserver.sink(receiveValue: { [weak self] scrollType in
            guard let self else { return }
            collection.isScrollEnabled = (scrollType == .collection)
        }).store(in: &bag)
        
        observer?.collectionReloader.sink { [weak self] isLoading in
            guard let self, isLoading else { return }
            collection.reloadData()
        }.store(in: &bag)
        
        productHelper = observer?.productHelper
    }
    
    override func getLayout() -> UICollectionViewLayout? {
        return layoutManager.getLayout(
            with: .productsListWithoutHeader
        )
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if collection.contentOffset.y < 0 && scrollView.isScrollingTop {
            observer?.scrollObserver.send(.table)
        }
    }
    
}

extension UIScrollView {
    
    func isHeaderPinned(forSection section: Int, inTableView tableView: UITableView) -> Bool {
        if section < tableView.numberOfSections {
            let headerRect = tableView.rectForHeader(inSection: section)
            let headerTopEdge = headerRect.origin.y - self.contentOffset.y
            let headerBottomEdge = headerTopEdge + headerRect.size.height
            
            return headerTopEdge <= 0 && headerBottomEdge > 0
        }
        
        return false
    }
}
