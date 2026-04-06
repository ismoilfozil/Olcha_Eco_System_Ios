//
//  CollectionLayoutManager.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 19/06/23.
//
import UIKit
import OlchaUI

public class CollectionLayoutManager {
    public func getFilterItems() -> Composition {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1),
            heightDimension: .absolute(40)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .fractionalHeight(1)
                             ),
            subitems: [item])
        horizontalGroup.interItemSpacing = .fixed(4)
        
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(40)),
            subitems: [horizontalGroup])
        
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.interGroupSpacing = 4
        return Composition(section: section)
    }
}
