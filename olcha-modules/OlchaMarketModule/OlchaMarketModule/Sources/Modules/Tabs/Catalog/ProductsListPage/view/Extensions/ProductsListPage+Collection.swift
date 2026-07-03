//
//  ProductsListPage+Collection.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/07/22.
//

import UIKit
import SkeletonView
import OlchaUI
extension ProductsListPage: UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections().count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let productsCount = productsSkeleton.getCount(products.count)
        switch sections()[section] {
        case .placeholder:
            return withPlaceholder ? ((productsCount == 0) ? 1 : 0) : 0
        case .products:
            return productsCount
        case .footer:
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections()[indexPath.section] {
        case .placeholder:
            let cell = collectionView.dequeue(EmptyPlaceholderItem.self, for: indexPath)
            cell.setup()
            cell.responder.mainButtonClick { [weak self] in
                guard let self else { return }
                popToRoot(mainTabIndex: OlchaTab.home)
            }
            return cell
        case .products:
            let cell = collectionView.dequeue(ProductCell.self, for: indexPath)
            cell.layoutIfNeeded()
            if indexPath.item < 12 {
                animatingCells[indexPath] = cell
            }
            
            cell.configure(skeleton: productsSkeleton)
            cell.productHelper = productHelper
            if products.isGreater(indexPath) {
                cell.configure(with: self.filters.cellType,
                               withSeparator: indexPath.item != self.products.count)
                cell.setup(with: self.products[indexPath.item])
            }
            
            cell.listSeparators(indexPath: indexPath)
            
            return cell
        case .footer:
            let cell = collectionView.dequeue(FooterCollectionItem.self, for: indexPath)
            cell.responder.configureIndicator()
            filters.paging.isLoading ? cell.responder.indicator.startAnimating() : cell.responder.indicator.stopAnimating()
            return cell
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeue(ProductsListHeader.self, for: indexPath, kind: UICollectionView.elementKindSectionHeader)
        header.delegate = self
        
        header.setup(filters: filters)
        
        return header
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? BaseCollectionCell)?.cellWillAppear()
        if sections()[indexPath.section] == .products {
            checkPaginator(index: indexPath.item)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections()[indexPath.section] {
        case .placeholder: break
        case .footer: break
        case .products:
            if products.isGreater(indexPath.item) {
                productHelper?.pushProduct.send(products[indexPath.item])
            }
        }
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkPaginator(scrollView: scrollView)

        let y = scrollView.contentOffset.y
        
        let pin = !(scrollView.panGestureRecognizer.translation(in: scrollView).y < 0)
        
        guard uiFilter.isPinned != pin else { return }
        if !pin && y < ((getHeader(collection)?.frame.height ?? 0) * 1.5) {
            uiFilter.isPinned = true
        } else {
            uiFilter.isPinned = pin
        }
        
        
        getHeader(collection)?.animate(show: uiFilter.isPinned)
    }
    
    
    private func getHeader(_ collection: UICollectionView) -> ProductsListHeader? {
        if let header = header {
            return header
        } else {
            header = collection.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: .init(item: 0, section: Section.products.rawValue)) as? ProductsListHeader
            return header
        }
    }
    
    private func pinHeader(pin: Bool) {
        guard let layout = layout else { return }
        guard let header = layout.section?.boundarySupplementaryItems.first else { return }
        
        header.pinToVisibleBounds = pin
    }
}

extension ProductsListPage: ProductsListHeaderProtocol {
    func changeProductType() {
        guard !productsSkeleton.isAnimating else { collection.reloadData(); return }
        if filters.cellType == .expand {
            filters.cellType = .shrink
        } else {
            filters.cellType = .expand
        }
        
        changeCellType()
    }
    
    func sortClicked(_ sender: UIView) {
        self.openMenus(sender: sender,
                       selectedSort: filters.selectedSort)
    }
}
