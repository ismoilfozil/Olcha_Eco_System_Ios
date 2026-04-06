//
//  OtherLayoutManager.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//

import Foundation
import OlchaUI
import UIKit
class OtherLayoutManager {
    enum LayoutType {
        case grid(count: Int)
        case vGrid(size: CGFloat)
        case vGridCount(count: Int, heightOffset: CGFloat)
        case cell(size: CGFloat)
        case full
    }
    
    func getLayout(with type: OtherLayoutManager.LayoutType, observer: PageObserver? = nil) -> Composition {
        switch type {
        case .grid(let count):
            return getGridLayout(count: count)
        case .vGrid(let size):
            return getVGridLayout(size: size)
        case .vGridCount(let count, let heightOffset):
            return getVGridLayout(count: count, heightOffset: heightOffset)
        case .cell(let size):
            return getGridLayout(size: size, observer: observer)
        case .full:
            return getFullLayout(observer: observer)
        }
    }
    
    private func getGridLayout(count: Int) -> Composition {
        let itemSize = equalSize()
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let minigroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalHeight(1),
                              heightDimension: .fractionalHeight(1)),
            subitems: [item])
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: equalSize(),
                                                       subitem: minigroup,
                                                       count: count)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return Composition(section: section)
    }
    
    private func getVGridLayout(count: Int, heightOffset: CGFloat) -> Composition {
        let itemSize = equalSize()
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let minigroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalHeight(1),
                              heightDimension: .fractionalHeight(1)),
            subitems: [item])
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: equalSize(),
                                                       subitem: minigroup,
                                                       count: count)
        
        let vGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .fractionalWidth(1 /  count.cgfloat * heightOffset)),
            subitems: [group])
        
        let section = NSCollectionLayoutSection(group: vGroup)
        
        return Composition(section: section)
    }
    
    private func getVGridLayout(size: CGFloat) -> Composition {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .absolute(size),
                                                     heightDimension: .absolute(size))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let minigroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(size)),
            subitems: [item])
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(size)),
            subitems: [minigroup])
        let section = NSCollectionLayoutSection(group: group)
        
        return Composition(section: section)
    }
    
    private func getGridLayout(size: CGFloat, observer: PageObserver? = nil) -> Composition {
        
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .absolute(size),
                                                     heightDimension: .absolute(size))
        let item = NSCollectionLayoutItem(layoutSize: equalSize())
        
        let minigroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: equalSize(),
            subitems: [item])
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitems: [minigroup])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = { (_, offset, _ ) in
            observer?.send(offset)
        }
        return Composition(section: section)
    }
    
    private func getFullLayout(observer: PageObserver? = nil) -> Composition {
        
        let item = NSCollectionLayoutItem(layoutSize: equalSize())
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: equalSize(), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = { (_, offset, env ) in
            observer?.send(offset)
        }
        
        return Composition(section: section)
        
    }
    
    private func equalSize() -> NSCollectionLayoutSize {
        .init(widthDimension: .fractionalWidth(1),
              heightDimension: .fractionalHeight(1))
    }
}
