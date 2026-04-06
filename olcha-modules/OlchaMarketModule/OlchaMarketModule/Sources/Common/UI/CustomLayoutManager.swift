//
//  CollectionLayoutManager.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
class CustomLayoutManager {


    static func getDiscountBannersLayout() -> UICollectionViewLayout {
        let itemsEdge = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let smallItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .fractionalHeight(1))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = itemsEdge

        let bigItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 2),
            heightDimension: .fractionalHeight(1))
        let bigItem = NSCollectionLayoutItem(layoutSize: bigItemSize)
        bigItem.contentInsets = itemsEdge


        let topGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.25 / 3)), subitems: [smallItem])


        let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.75 / 3)), subitems: [bigItem])


        let mainGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [topGroup, bottomGroup])
        mainGroup.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)

        let section = NSCollectionLayoutSection(group: mainGroup)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    static func getTripledLayout() -> UICollectionViewLayout {
        let itemsEdge = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)

        let smallItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .fractionalHeight(1))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = itemsEdge


        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [smallItem])




        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

}
