//
//  BrandLayoutManager.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/09/22.
//

import UIKit
import OlchaUI
class BrandLayoutManager {
    
    private let catalogManager = CatalogLayoutManager()
    
    enum LayoutType {
        case products(type: ProductCell.CellType,
                      tagsEmpty: Bool)
    }
    
    func getLayout(with type: BrandLayoutManager.LayoutType,
                   observer: PageObserver? = nil) -> Composition {
        
        switch type {
            case .products(let type, let tagsEmpty):
            return getProducts(type: type, tagsEmpty: tagsEmpty)
        }
    }
    
    private func getProducts(type: ProductCell.CellType,
                             tagsEmpty: Bool,
                             filtersEmpty: Bool = false,
                             productsHeader: Bool = true) -> Composition {
        
        let layout = Composition(sectionProvider: { (section: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let section = BrandProductsPage.Section(rawValue: section)
            
            switch section {
            case .sliders:
                return self.getSlidersSection()
            case .bigBanner:
                return self.getBigBannerSection()
            case .flagmans:
                return self.getFlagmansSection()
            case .products:
                return self.getProductsSection(type: type,
                                               tagsEmpty: tagsEmpty,
                                               filtersEmpty: filtersEmpty,
                                               productsHeader: productsHeader)
            default:
                return self.getBestsellerSection()
            
            }
            
        }, configuration: .init())
        return layout
    }
    
    private func getProductsSection(type: ProductCell.CellType,
                                    tagsEmpty: Bool,
                                    filtersEmpty: Bool = false,
                                    productsHeader: Bool = true) -> NSCollectionLayoutSection {
        catalogManager.getProductsListSection(type: type,
                                              tagsEmpty: tagsEmpty,
                                              filtersEmpty: filtersEmpty,
                                              productsHeader: productsHeader)
    }
    
    private func getSlidersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(160)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = []
        return section
    }
    
    private func getBigBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = []
        return section
    }
    
    private func getFlagmansSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(192))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .estimated(1)),
            subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        section.boundarySupplementaryItems = []
        return section
    }
    
    private func getBestsellerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(Constants.promotedRoomEstimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .estimated(1))
        let header = NSCollectionLayoutItem(layoutSize: headerSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .estimated(1)),
            subitems: [header, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = []
        return section
    }
    
    private func equalSize() -> NSCollectionLayoutSize {
        .init(widthDimension: .fractionalWidth(1),
              heightDimension: .fractionalHeight(1))
    }
}
