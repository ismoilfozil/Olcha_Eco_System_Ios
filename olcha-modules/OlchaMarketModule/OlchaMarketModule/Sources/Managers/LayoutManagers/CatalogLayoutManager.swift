//
//  CatalogLayoutManager.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/07/22.
//

import UIKit
import OlchaUI
public class CatalogLayoutManager {
    enum LayoutType {
        case mainCatalog
        case productsList(type: ProductCell.CellType, tagsEmpty: Bool)
        case productsListWithoutHeader
        case filterList
        case colorFilterList
    }
    
    func getLayout(with type: CatalogLayoutManager.LayoutType, pageObserver: PageObserver? = nil) -> Composition {
        switch type {
        case .mainCatalog:
            return getMainCatalogLayout()
        case .productsList(let type, let tagsEmpty):
            return getProductsListPageLayout(type: type,
                                             observer: pageObserver,
                                             tagsEmpty: tagsEmpty)
        case .productsListWithoutHeader:
            return getProductsListPageLayout(type: .shrink, observer: pageObserver, tagsEmpty: true, withHeader: false)
        case .filterList:
            return getFilterItems()
        case .colorFilterList:
            return getColorFilterItems()
        }
    }
    
    private func getMainCatalogLayout() -> Composition {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            ),
            subitem: item,
            count: 3)
        
        horizontalGroup.interItemSpacing = .fixed(8)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: equalSize(), subitems: [horizontalGroup])
        
        
        let mainGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(104)
        ), subitems: [verticalGroup])
         
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        section.interGroupSpacing = 16
        return Composition(section: section)
    }
    
    private func getPopularSection() -> NSCollectionLayoutSection {
        let popularItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let popularItem = NSCollectionLayoutItem(layoutSize: popularItemSize)
        
        let popularGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(412)),
            subitems: [popularItem]
        )
        
        let popularSection = NSCollectionLayoutSection(group: popularGroup)
        popularSection.boundarySupplementaryItems = []
        return popularSection
    }
    
    func getProductsListSection(type: ProductCell.CellType,
                                tagsEmpty: Bool,
                                filtersEmpty: Bool = false,
                                productsHeader: Bool = true
    ) -> NSCollectionLayoutSection {
        
        let productItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / ((type == .shrink) ? 2 : 1)),
            heightDimension: .fractionalHeight(1))
        let productItem = NSCollectionLayoutItem(layoutSize: productItemSize)
        
        let height = (type == .shrink) ? Constants.shrinkProductCellHeight : Constants.expandProductCellHeight
        
        let productsGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(height)),
            subitems: [productItem, productItem])
        productsGroup.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let productsSection = NSCollectionLayoutSection(group: productsGroup)
        productsSection.interGroupSpacing = 0
        
        ///
        ///
        /// Filter header view
        ///
        ///
        
        
        let header = getProductsListHeader(tagsEmpty: tagsEmpty, filtersEmpty: filtersEmpty)
        productsSection.boundarySupplementaryItems = productsHeader ? [header] : []
        
        return productsSection
    }
    
    
    private func getProductsListHeader(tagsEmpty: Bool, filtersEmpty: Bool) -> NSCollectionLayoutBoundarySupplementaryItem {
        var height: CGFloat = 64.0
        
        if !tagsEmpty {
            height += 32
        }
        
        if !filtersEmpty {
            height += 64.0
        }
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height))
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        headerElement.pinToVisibleBounds = true
        headerElement.zIndex = Int.max
        headerElement.pinToVisibleBounds = true
        
        return headerElement
    }
    
    private func getProductsListPageLayout(type: ProductCell.CellType,
                                           observer: PageObserver?,
                                           tagsEmpty: Bool,
                                           withHeader: Bool = true
    ) -> Composition {
        let layout = Composition(sectionProvider: { (section: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let pageSection = ProductsListPage.Section(rawValue: section)
            
            switch pageSection {
            case .placeholder:
                return self.getProductsListPlaceholder()
            case .footer:
                return self.getProductsListFooter()
            default:
                return self.getProductsListSection(type: type, tagsEmpty: tagsEmpty, productsHeader: withHeader)
            }
            
        }, configuration: .init())
        
        return layout
    }
    
    private func getProductsListFooter() -> NSCollectionLayoutSection {
        let itemSize = equalSize()
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)),
            subitems: [item])
        
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 0
        
        return section
    }
    
    private func getProductsListPlaceholder() -> NSCollectionLayoutSection {
        let itemSize = equalSize()
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.6)),
            subitems: [item])
        
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 0
        
        return section
    }
    private func getFilterItems() -> Composition {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1),
            heightDimension: .absolute(32)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: equalSize(),
            subitems: [item])
        horizontalGroup.interItemSpacing = .fixed(4)
        
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(32)),
            subitems: [horizontalGroup])
        
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.interGroupSpacing = 4
        return Composition(section: section)
    }
    
    private func getColorFilterItems() -> Composition {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(32),
            heightDimension: .absolute(32)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .absolute(32),
                              heightDimension: .absolute(64)),
            subitems: [item, item])
        
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .absolute(32), heightDimension: .absolute(64)),
            subitems: [item])
        horizontalGroup.interItemSpacing = .fixed(4)
        
        
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.interGroupSpacing = 4
        section.orthogonalScrollingBehavior = .continuous
        return Composition(section: section)
    }
    
    private func getBannerLayout(observer: PageObserver?, isEmpty: Bool) -> NSCollectionLayoutSection {
        let itemsEdge = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let itemSize = equalSize()
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemsEdge
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(isEmpty ? 0 : 136)),
            subitems: [item])
        group.contentInsets = itemsEdge
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { (_, offset, _ ) in
            observer?.send(offset)
        }
        

        return section
    }
    
    private func getPaginatorLayout(isEmpty: Bool) -> NSCollectionLayoutSection {
        
        let itemSize = equalSize()
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(isEmpty ? 10 : 0)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func equalSize() -> NSCollectionLayoutSize {
        .init(widthDimension: .fractionalWidth(1),
              heightDimension: .fractionalHeight(1))
    }
}
