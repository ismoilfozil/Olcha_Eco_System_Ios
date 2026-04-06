//
//  DetailedCatalogListPage+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/08/22.
//
import OlchaUI
import UIKit
extension DetailedCatalogListPage: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionItem = sections[section]
        
        switch sectionItem {
        case .categorySelect:
            return 1
        case .banner:
            return helper.initialReloaded ? ((helper.sliders?.banners?.isEmpty ?? true) ? 0 : 1) : 0
        case .categories:
            return helper.initialReloaded ? helper.categories.count : 0
        case .popular:
            return helper.initialReloaded ? popularProductsCount() : 0
        case .categoryProducts:
            return helper.loadedCategoryProducts.count
        case .brands:
            return (helper.brands == nil) ? 0 : 1
        case .products:
            return helper.isReadyProducts ? products.count : 0
        case .footer:
            return 1
        default: return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]

        switch section {
        case .categorySelect:
            let cell = collectionView.dequeue(CatalogSelectRoom.self, for: indexPath)
            return cell
        case .banner:
            
            let cell = collectionView.dequeue(CatalogBannersRoom.self, for: indexPath)
            cell.pushSliderObserver = pushSliderObserver
            cell.setup(with: helper.sliders)
            return cell
        case .categories:
            let cell = collectionView.dequeue(BackgroundedImage.self, for: indexPath)
            let item = helper.categories[indexPath.row]
            cell.setup(background: item.background_image,
                       main: item.main_image,
                       title: item.getName())
            return cell
        case .popular:
            let cell = collectionView.dequeue(PromotedCollectionRoomWithHeader.self, for: indexPath)
            cell.header.configure(with: .title("popular_products".localized()))
            
            cell.responder.productHelper = productHelper
            cell.responder.setup(with: helper.popularProducts)
            
            cell.responder.configure(style: .white,
                                     withShowAll: true,
                                     cellType: .shrink)
            
            
            cell.responder.seeAllButton.clicked { [weak self] in
                guard let self = self else { return }
                let filters =  ProductListFilters()
                filters.category = self.category
                filters.productsType = .popular
                self.coordinator?.pushProductsList(filters: filters)
            }
            return cell
            
        case .categoryProducts:
            let rowItem = helper.loadedCategoryProducts[indexPath.item]
            
            if (rowItem.categoryProducts?.products?.isEmpty ?? true) {
                let cell = collectionView.dequeue(EmptyCell.self, for: indexPath)
                return cell
            }
            let cell = collectionView.dequeue(PromotedCollectionRoomWithHeader.self, for: indexPath)
            cell.categoryProductsObserver = categoryProductsObserver
            
            
            cell.responder.productHelper = productHelper
            
            
            cell.category = rowItem
            cell.header.configure(with: .title(rowItem.getName()))
            cell.responder.setup(with: rowItem.categoryProducts)
            cell.responder.configure(style: .white,
                                     withShowAll: true,
                                     cellType: .shrink)
            
            cell.responder.seeAllButton.clicked { [weak self] in
                guard let self = self else { return }
                self.pushAllProductObserver.send(rowItem)
            }
            return cell
        case .brands:
            let cell = collectionView.dequeue(BrandsCollectionRoom.self, for: indexPath)
            cell.responder.pushBrandObserver = pushBrandObserver
            cell.responder.pushAllBrandsObserver = pushAllBrandsObserver
            cell.responder.pushCategoryObserver = pushCategoryObserver
            cell.responder.style = .gray
            cell.responder.setup(with: helper.brands, withShowAll: true)
            return cell
        case .products:
            let cell = collectionView.dequeue(ProductCell.self, for: indexPath)
            cell.layoutIfNeeded()
//            cell.configure(skeleton: productsSkeleton)
            cell.productHelper = productHelper
            if products.isGreater(indexPath) {
                cell.configure(with: self.filters.cellType,
                               withSeparator: indexPath.item != self.products.count)
                cell.setup(with: self.products[indexPath.item])
                checkPaginator(index: indexPath.item)
            }
            cell.listSeparators(indexPath: indexPath)
            return cell
        case .footer:
            let cell = collectionView.dequeue(FooterCollectionItem.self, for: indexPath)
            cell.observeIndicator(state: !helper.isCategoryProductsLoaded())
            return cell
        default: return .init()
        }
        return .init()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            return collectionHeader(indexPath)
        }
        return UICollectionReusableView(frame: .zero)
    }
    
    func collectionHeader(_ indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        if section == .products {
            if helper.isReadyProducts {
                let header = collection.dequeue(ProductsListHeader.self, for: indexPath, kind: UICollectionView.elementKindSectionHeader)
                header.hideFilters = true
                header.delegate = self
                header.setup(filters: filters)
                header.animate(show: isPinned, withAnimation: false)
                return header
            } else {
                let header = collection.dequeue(EmptyHeader.self, for: indexPath, kind: UICollectionView.elementKindSectionHeader)
                return header
            }
        } else {
            return UICollectionReusableView(frame: .zero)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? BaseCollectionCell)?.cellWillAppear()
        let section = sections[indexPath.section]
        
        switch section {
        case .categoryProducts:
            checkCategoriesPaginator(index: indexPath.item)
            loadCategoryBrands()
            break
        default: break
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch sections[indexPath.section] {
        case .categorySelect:
            let filter = ProductListFilters()
            filter.category = self.category
            filter.catalogStack = coordinator?.selectedCatalogStack ?? []
            filter.selectedManufacturer = brand
            coordinator?.presentCategoryListFilterModal(filters: filter)
            break
        case .categories:
            pushSubcatalogObserver.send(helper.categories[indexPath.item])
            break
        case .products:
            productHelper.pushProduct.send(products[indexPath.item])
            break
        default: break
        }
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y

        let pin = !(scrollView.panGestureRecognizer.translation(in: scrollView).y < 0)

//        guard isPinned != pin else { return }
        guard let currentY = getHeader(collection)?.convert(getHeader(collection)?.frame ?? .zero,
                                                            to: container).origin.y else { return }
        if !pin && currentY > y {
            isPinned = true
        } else {
            isPinned = pin
        }

        getHeader(collection)?.animate(show: isPinned)
    }
      
      
      func getHeader(_ collection: UICollectionView) -> ProductsListHeader? {
//          if let header = header {
//              return header
//          } else {
              let header = collection.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: .init(item: 0, section: Section.products.rawValue)) as? ProductsListHeader
                self.header = header
              return header
//          }
      }
      
      private func pinHeader(pin: Bool) {
          guard let layout = layout else { return }
          guard let header = layout.section?.boundarySupplementaryItems.first else { return }
          
          header.pinToVisibleBounds = pin
      }
}

extension DetailedCatalogListPage {
    
    func isSeparator(_ indexPath: IndexPath) -> Bool {
        indexPath.row == 2
    }
    
//    func getSection(in indexPath: IndexPath) -> Int {
//        (indexPath.section - staticSections.count)
//    }
    
    func popularProductsCount() -> Int {
        if collection.isLoaded(at: Section.popular.rawValue) {
            return (helper.popularProducts?.products?.isEmpty ?? true) ? 0 : 1
        } else {
            return 1
        }
    }
}


extension DetailedCatalogListPage: ProductsListHeaderProtocol {
    func changeProductType() {
//        guard !productsSkeleton.isAnimating else { collection.reloadData(); return }
        if self.filters.cellType == .expand {
            self.filters.cellType = .shrink
        } else {
            self.filters.cellType = .expand
        }
        
        changeCellType()
    }
    
    func sortClicked(_ sender: UIView) {
        self.openMenus(sender: sender,
                       selectedSort: self.filters.selectedSort)
    }
    
    func reload(section: Int) {

        self.collection.performBatchUpdates {
            self.collection.reloadSections(.init(integer: section))
        }

    }
    
    func changeCellType(animation: Bool = true) {
        
        layout = manager.getLayout(
            with: .products(cellType: filters.cellType,
                            categoriesCount: helper.categories.count,
                            productsHeader: true
                           )
        )
        
        if let layout = layout {
            collection.collectionViewLayout = layout
        }
        
        guard animation else { return }
        
        guard !isAnimating else {
            collection.reloadData()
            return
        }
        
        isAnimating = true
        collection.animateProductShrink(filters.cellType,
                                        section: Section.products.rawValue) { [ weak self ] in
            guard let self = self else { return }
            
            self.isAnimating = false
        }
    }
}
