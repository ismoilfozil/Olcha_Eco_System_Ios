//
//  DetailedCatalogLayout.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/12/22.
//
import OlchaUI
import UIKit
class DetailedCatalogLayoutManager {
    
    private let catalogManager = CatalogLayoutManager()
    private let homeManager =  HomeLayoutManager()
    
    enum LayoutType {
        case products(cellType: ProductCell.CellType,
                      categoriesCount: Int,
                      productsHeader: Bool
        )
    }
    
    func getLayout(with type: DetailedCatalogLayoutManager.LayoutType,
                   observer: PageObserver? = nil
    ) -> Composition {
        
        switch type {
        case .products(let cellType, let categoriesCount, let productsHeader):
            return getProducts(cellType: cellType,
                               categoriesCount: categoriesCount,
                               productsHeader: productsHeader)
        }
    }
    
    private func getProducts(cellType: ProductCell.CellType,
                             categoriesCount: Int,
                             productsHeader: Bool
    ) -> Composition {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let emptySection = NSCollectionLayoutSection(
            group: .horizontal(
                layoutSize: .init(widthDimension: .absolute(0),
                                  heightDimension: .absolute(0)
                                 ) , subitems: [item] ))
        
        let productsSection = getProductsSection(type: cellType,
                                                 productsHeader: productsHeader)
        
        let layout = Composition(sectionProvider: { [weak self] (section: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            guard let self = self else { return emptySection }
            let section = self.getSection(section: section,
                                          categoriesCount: categoriesCount)
            
            switch section {
            case .categorySelect:
                return self.getCategorySelectSection()
            case .categories:
                return self.getCategoriesSection(count: 3, offset: 1.3)
            case .banner:
                return self.getSlidersSection()
            case .popular:
                return self.getCategoryProductsSection()
            case .categoryProducts:
                return self.getCategoryProductsSection()
            case .brands:
                return self.getBrandsSection()
            case .products:
                return productsSection
            case .footer:
                return self.getFooterSection()
            default:
                return emptySection
            
            }
            
        }, configuration: .init())
        layout.section = productsSection
        return layout
    }
    
    func getSection(section: Int, categoriesCount: Int) -> DetailedCatalogListPage.Section {
        switch section {
        case DetailedCatalogListPage.Section.categorySelect.rawValue:
            return .categorySelect
        case DetailedCatalogListPage.Section.banner.rawValue:
            return .banner
        case DetailedCatalogListPage.Section.categories.rawValue:
            return .categories
        case DetailedCatalogListPage.Section.popular.rawValue:
            return .popular
        case DetailedCatalogListPage.Section.categoryProducts.rawValue:
            return .categoryProducts
        case DetailedCatalogListPage.Section.brands.rawValue:
            return .brands
        case DetailedCatalogListPage.Section.products.rawValue:
            return .products
        case DetailedCatalogListPage.Section.footer.rawValue:
            return .footer
        default: return .none
        }
    }
    
    
    
    private func getCategorySelectSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(76)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = []
        return section
    }
    
    private func getCategoriesSection(count: Int, offset: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/count.cgfloat),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: equalSize(),
            subitems: [item, item, item]
        )
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .fractionalWidth((1 / count.cgfloat) * offset)),
            subitems: [horizontalGroup])
        verticalGroup.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.boundarySupplementaryItems = []
        return section
    }
    
    private func getProductsSection(type: ProductCell.CellType, productsHeader: Bool) -> NSCollectionLayoutSection {
        catalogManager.getProductsListSection(type: type, tagsEmpty: true, filtersEmpty: true, productsHeader: productsHeader)
    }
    
    private func getBrandsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(1)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = []
        return section
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
    
    private func getFooterSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(40)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = []
        return section
    }
    
    private func getCategoryProductsSection() -> NSCollectionLayoutSection {
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
