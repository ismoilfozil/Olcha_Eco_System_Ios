//
//  CollectionLayoutManager.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 20/02/24.
//

import UIKit
public class NotificationLayoutManager {
    public enum LayoutType {
        case header
    }
    
    public init() {}
    
    public func getLayout(with type: LayoutType) -> Composition {
        switch type {
        case .header:
            return getFilterItems()
        }
    }
    
    private func getFilterItems() -> Composition {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1),
            heightDimension: .absolute(64)
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
        
    private func equalSize() -> NSCollectionLayoutSize {
        .init(widthDimension: .fractionalWidth(1),
              heightDimension: .fractionalHeight(1))
    }
}
