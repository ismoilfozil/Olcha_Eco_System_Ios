//
//  CustomLayout.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/07/22.
//

import UIKit
import Combine
import OlchaUI

class HomeLayoutManager {
    
    private let edge_8 = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
    static let discountBannersEdge: CGFloat = 8
    
    enum LayoutType {
        case banner
        case tripleGrid
        case categories
        case discounts
        case newCategories
        case brands(CGFloat)
        case gridItem(CGSize)
        case news
        case horizontalProducts(space: CGFloat)
        case verticalProducts
        case groupedProducts(count: Int)
    }
    
    func getLayout(with type: HomeLayoutManager.LayoutType, observer: PageObserver? = nil) -> Composition {
        switch type {
        case .banner:
            return getBannerLayout(observer: observer)
        case .tripleGrid:
            return getTripleGridLayout()
        case .categories:
            return getCategoriesLayout(observer: observer)
        case .discounts:
            return getDiscountsLayout()
        case .newCategories:
            return getNewCategoriesLayout()
        case .brands(let offset):
            return getBrandsLayout(offset: offset)
        case .gridItem(let size):
            return getGridItem(size: size)
        case .news:
            return getNewsLayout()
        case .horizontalProducts(let space):
            return getHorizontalProductsLayout(space: space)
        case .verticalProducts:
            return getVerticalProductsLayout()
        case .groupedProducts(let count):
            return groupedProducts(count: count)
        }
    }
    
    
    private func getTripleGridLayout() -> Composition {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = edge_8
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: equalSize(),
            subitems: [item])
        let horizontalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1)), subitems: [group])
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .continuous
        
        
        return Composition(section: section)
    }
    
    private func getBannerLayout(observer: PageObserver?) -> Composition {
        let itemsEdge = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let itemSize = equalSize()
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemsEdge
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: equalSize(),
            subitems: [item])
        group.contentInsets = itemsEdge
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { (_, offset, _ ) in
            observer?.send(offset)
        }
        

        return Composition(section: section)
    }
    
    private func getCategoriesLayout(observer: PageObserver?) -> Composition {
        let groupEdge = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)),
            subitems: [item])
        horizontalGroup.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: equalSize(),
            subitems: [horizontalGroup, horizontalGroup])
        
        let mainGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: equalSize(),
            subitems: [verticalGroup])
        
        mainGroup.contentInsets = groupEdge
        
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.orthogonalScrollingBehavior = .paging
        
        section.visibleItemsInvalidationHandler = { (_, offset, _ ) in
            observer?.send(offset)
        }
        
        return Composition(section: section)
    }
    
    
    private func getDiscountsLayout() -> Composition {
//        let itemsEdge = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let smallItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .fractionalHeight(1))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)

//        let bigItemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1 / 2),
//            heightDimension: .fractionalHeight(1))
//        let bigItem = NSCollectionLayoutItem(layoutSize: bigItemSize)
//        bigItem.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)


        let topGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .fractionalHeight(1)),
            subitems: [smallItem])
        topGroup.contentInsets = .init(top: 0,
                                       leading: HomeLayoutManager.discountBannersEdge,
                                       bottom: 8,
                                       trailing: HomeLayoutManager.discountBannersEdge)
//        let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.75 / 3)), subitems: [bigItem])
//        bottomGroup.contentInsets = .init(top: 8, leading: 8, bottom: 0, trailing: 8)

        let mainGroup = NSCollectionLayoutGroup.vertical(layoutSize: equalSize(), subitems: [topGroup])
//        mainGroup.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)

        let section = NSCollectionLayoutSection(group: mainGroup)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        let layout = Composition(section: section)
        
        return layout
    
    }
    
    private func getNewCategoriesLayout() -> Composition {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1 / 2))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .fractionalHeight(1)),
            subitems: [item, item])
        
        
        let cellWidth: CGFloat = 96.0
        let cellLeftRightEdge: CGFloat = 8.0 + 8.0
        
        let mainGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .absolute(cellWidth + cellLeftRightEdge),
                              heightDimension: .fractionalHeight(1)),
            subitems: [verticalGroup])
        mainGroup.contentInsets = .init(top: 0, leading: cellLeftRightEdge / 2, bottom: 0, trailing: cellLeftRightEdge / 2)
        
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = edge_8
        return Composition(section: section)
    }
    
    
    private func getBrandsLayout(offset: CGFloat = 2.0) -> Composition {
        return Composition(section: getBrandsLayoutSection(offset: offset))
    }
    
    func getBrandsLayoutSection(offset: CGFloat = 2.0) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1 / offset))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .fractionalHeight(1)),
            subitems: [item, item])
        
        let mainGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(0.9),
                              heightDimension: .fractionalHeight(1)),
            subitems: [verticalGroup])
        
        
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        return section
    }
    
    private func getGridItem(size: CGSize) -> Composition {
        let edge: CGFloat = 8.0
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(size.width + edge),
            heightDimension: .absolute(size.height + edge)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: equalSize())
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        group.contentInsets = .init(top: edge, leading: edge, bottom: edge, trailing: edge)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = edge_8
        return Composition(section: section)
    }
    
    private func getNewsLayout() -> Composition {
        let itemSize = equalSize()
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalHeight(1))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = edge_8
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = edge_8
        return Composition(section: section)
    }
    
    private func getHorizontalProductsLayout(space: CGFloat) -> Composition {
        let itemSize = equalSize()
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.shrinkProductCellWidth),
            heightDimension: .absolute(Constants.shrinkProductCellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = space
        
        
        return Composition(section: section)
    }
    private func getVerticalProductsLayout() -> Composition {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constants.expandProductCellHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        
        
        return Composition(section: section)
    }

    
    private func groupedProducts(count: Int) -> Composition {
        let isExpaned = (count > 2)
        let space = 0.0
        let cellHeight = Constants.shrinkProductCellHeight
        let groupHeight = isExpaned ? (cellHeight * 2 + space) : cellHeight
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/2),
            heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
             heightDimension: .absolute(cellHeight))
             
            
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        
        let mainGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(groupHeight)),
            subitems: [horizontalGroup, horizontalGroup])
        
        mainGroup.interItemSpacing = .fixed(space)
        let section = NSCollectionLayoutSection(group: mainGroup)
        return Composition(section: section)
    }
    
    
    
    private func equalSize() -> NSCollectionLayoutSize {
        .init(widthDimension: .fractionalWidth(1),
              heightDimension: .fractionalHeight(1))
    }
    
    
}
