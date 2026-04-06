//
//  HomePage2+Table.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 23/08/22.
//

import UIKit
import OlchaUI

extension HomePage: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .mainBanner:
            return 1
        case .categories:
            return 1
        case .dailyProducts:
            return 4
        case .gridBanners:
            return self.discountBanners.isEmpty ? 0 : 2
        case .builder(let componentType):
            let builderSection = getSection(in: .init(row: 0, section: section))
            
            let roomType = getRoomType(type: componentType)
            
            if builderSection > -1 {
                switch roomType {
                case .verticalProducts:
                    return 3
                case .horizontalProducts:
                    return 3
                case .groupedProducts:
                    return 3
                case .horizontalGridCategories:
                    return 3
                case .brands:
                    return 2
                case .news:
                    return 2
                case .dotsPicture:
                    return 2
                case .none:
                    return 3
                
                }
            } else {
                return 0
            }
        case .products:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        
        switch section {
            
        case .mainBanner:
            let cell = tableView.dequeue(MainBannerRoom.self, for: indexPath)
            cell.skeleton = mainBannersSkeleton
            cell.setup(with: mainBanners)
            cell.pushSliderObserver = pushSliderObserver
            return cell
            
        case .categories:
            let cell = tableView.dequeue(CategoriesRoom.self, for: indexPath)
            cell.skeleton = categorySkeleton
            cell.setup(with: self.categories)
            cell.pushCategoryObserver = pushMainCategoryObserver
            cell.backgroundColor = .olchaWhite
            return cell
            
        case .dailyProducts:
            switch indexPath.item {
            case 1:
                let cell = tableView.dequeue(ComponentHeader.self, for: indexPath)
                cell.configure(with: .timeTitle("day_products".localized()))
                cell.responder.style = .gray
                return cell
            case 2:
                let cell = tableView.dequeue(HorizontalPromotedRoom.self, for: indexPath)
                cell.responder.skeleton = dailyProductsSkeleton
                cell.responder.productHelper = productHelper
                cell.setup(with: dailyProducts)
                cell.configure(style: .gray,
                               withShowAll: false,
                               cellType: .shrink,
                               space: 0)
                return cell
            default:
                let cell = tableView.dequeue(FooterItem.self, for: indexPath)
                cell.responder.withSeparator = false
                cell.responder.style = (indexPath.item == 4) ? .white : .gray
                return cell
            }
        case .gridBanners:
            if indexPath.item == 1 {
                let cell = tableView.dequeue(FooterItem.self, for: indexPath)
                cell.responder.withSeparator = false
                cell.responder.style = .white
                return cell
            } else {
                let cell = tableView.dequeue(DiscountBannersRoom.self, for: indexPath)
                cell.setup(with: self.discountBanners)
                cell.pushDiscountObserver = pushDiscountObserver
                return cell
            }
        case .builder:
            return getRoom(model: componentModels[getSection(in: indexPath)],
                           tableView: tableView,
                           indexPath: indexPath)
        case .products:
            let cell = tableView.dequeue(HomeProductPageControlRoom.self, for: indexPath)
            cell.observer = productsObserver
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = sections[indexPath.section]
        var height: CGFloat
        switch section {
        case .dailyProducts:
            
            if indexPath.row == 1 || indexPath.row == 2 {
                height = section.height
            } else {
                height = section.footer
            }
        case .gridBanners:
            if indexPath.row == 1 {
                height = section.footer
            } else {
                height = section.height
            }
        case .builder(let componentType):
            let roomType = getRoomType(type: componentType)
            
            if isFooterItem(indexPath: indexPath, type: roomType) {
                height = section.footer
            } else {
                height = section.height
            }
        case .products:
            height = getProductsSectionHeight()
        default:
            height = section.height
        }
        return tableView.cacheHeights(height, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .products:
            return segmentHeaderHeight
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case .products:
            let headerView = tableView.dequeue(HomeProductPageControlRoomHeader.self)
            headerView.observer = productsObserver
            return headerView
        default:
            return UIView(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let index = getSection(in: indexPath)
        
        if index > -1 {
            loadComponentDatas(index: index)
//            loadComponentDatas(index: index + 1)
//            loadComponentDatas(index: index + 2)
//            loadComponentDatas(index: index + 3)
//            loadComponentDatas(index: index + 4)
        }
        
    }
    
    func getSection(in indexPath: IndexPath) -> Int {
        (indexPath.section - staticSections.count)
    }
    
    func getRoomType(type: String?) -> HomeRoomType {
        HomeRoomType(rawValue: type ?? "") ?? .none
    }
    
    func isHeaderItem(indexPath: IndexPath, type: HomeRoomType) -> Bool {
        if type.withHeader {
            return (indexPath.row == 0)
        } else {
            return false
        }
    }
    
    func isFooterItem(indexPath: IndexPath, type: HomeRoomType) -> Bool {
        if type.withHeader {
            return (indexPath.row == 2)
        } else {
            return (indexPath.row == 1)
        }
    }
    
    private func getProductsSectionHeight() -> CGFloat {
        return table.frame.height - segmentHeaderHeight
    }
}

private extension HomePage {
    func getRoom(model: HomeComponentModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let componentType = getRoomType(type: model.component?.component_type ?? "")
        
        if isHeaderItem(indexPath: indexPath, type: componentType) {
            let cell = tableView.dequeue(ComponentHeader.self, for: indexPath)
            return getHeader(model: model.component, cell: cell, componentType: componentType)
        } else if isFooterItem(indexPath: indexPath, type: componentType) {
            let cell = tableView.dequeue(FooterItem.self, for: indexPath)
            cell.responder.style = .white
            cell.responder.withSeparator = false
            return cell
        } else {
            switch componentType {
            case .verticalProducts:
                let cell = tableView.dequeue(VerticalPromotedRoom.self, for: indexPath)
                return getVerticalProductsRoom(model: model, cell: cell, type: .expand)
            case .horizontalGridCategories:
                let cell = tableView.dequeue(NewCategoriesRoom.self, for: indexPath)
                return getCategoriesRoom(model: model, cell: cell)
            case .brands:
                if (model.brands?.manufacturers?.count ?? 0) > 1 {
                    let cell = tableView.dequeue(DoubledBrandsRoom.self, for: indexPath)
                    return getDoubledBrandsRoom(model: model, cell: cell)
                } else {
                    let cell = tableView.dequeue(SingleBrandsRoom.self, for: indexPath)
                    return getSingleBrandsRoom(model: model, cell: cell)
                }
            case .dotsPicture:
                let cell = tableView.dequeue(DotPictureRoom.self, for: indexPath)
                dotPictureRoom = cell
                return getDotPictureRoom(model: model, cell: cell)
            case .news:
                let cell = tableView.dequeue(NewsRoom.self, for: indexPath)
                return getNewsRoom(model: model, cell: cell)
            case .horizontalProducts:
                let cell = tableView.dequeue(HorizontalPromotedRoom.self, for: indexPath)
                return getHorizontalProductsRoom(model: model, cell: cell, type: .shrink)
            case .groupedProducts:
                let cell = tableView.dequeue(GroupedProductsRoom.self, for: indexPath)
                return getGroupedProductsRoom(model: model, cell: cell)
            case .none:
                return .init()
            }
        }
    }
    
    func getVerticalProductsRoom(model: HomeComponentModel,
                                   cell: VerticalPromotedRoom,
                                   type: ProductCell.CellType) -> VerticalPromotedRoom {
        cell.responder.skeleton = .init(count: 0, isAnimating: false)
        cell.responder.productHelper = productHelper
        cell.setup(with: model.productsData, maximumLimit: (type == .expand) ? 4 : 0)
        cell.responder.seeAllButton.clicked { [weak self] in
            guard let self = self else { return }
            if let content = model.component?.content {
                self.componentPush(model: content)
            }
        }
        
        cell.configure(style: .white,
                       withShowAll: (model.component?.link != ""),
                       cellType: type)
        
        return cell
    }
    
    func getHorizontalProductsRoom(model: HomeComponentModel,
                                   cell: HorizontalPromotedRoom,
                                   type: ProductCell.CellType) -> HorizontalPromotedRoom {
        cell.responder.topEdge = 0
        cell.responder.skeleton = .init(count: 0, isAnimating: false)
        cell.responder.productHelper = productHelper
        cell.setup(with: model.productsData, maximumLimit: (type == .expand) ? 4 : 0)
        cell.responder.seeAllButton.clicked { [weak self] in
            guard let self = self else { return }
            if let content = model.component?.content {
                self.componentPush(model: content)
            }
        }
        
        cell.configure(style: .white,
                       withShowAll: (model.component?.link != ""),
                       cellType: type)
        
        return cell
    }
    
    func getGroupedProductsRoom(model: HomeComponentModel,
                                cell: GroupedProductsRoom) -> GroupedProductsRoom {

        cell.responder.skeleton = .init(count: 0, isAnimating: false)
        cell.responder.productHelper = productHelper
        cell.responder.setup(with: model.productsData)
        cell.responder.seeAllButton.clicked { [weak self] in
            guard let self = self else { return }
            if let content = model.component?.content {
                self.componentPush(model: content)
            }
        }
        return cell
    }
    
    func getCategoriesRoom(model: HomeComponentModel,
                           cell: NewCategoriesRoom) -> NewCategoriesRoom {
        cell.footer.clicked { [weak self] in
            guard let self = self else { return }
            if let content = model.component?.content {
                self.componentPush(model: content)
            }
        }
        cell.pushCategoryObserver = pushCategoryObserver
        cell.setup(with: model.categoriesData, withShowAll: (model.component?.link ?? "") != "")
        return cell
    }
    
    
    func getSingleBrandsRoom(model: HomeComponentModel,
                             cell: SingleBrandsRoom) -> SingleBrandsRoom {
        cell.pushBrandObserver = pushBrandObserver
        cell.pushCategoryObserver = pushCategoryObserver
        cell.pushAllBrandsObserver = pushAllBrandsObserver
        cell.style = .gray
        cell.setup(with: model.brands, withShowAll: (model.component?.link != ""))
        
        return cell
    }
    
    func getDoubledBrandsRoom(model: HomeComponentModel,
                              cell: DoubledBrandsRoom) -> DoubledBrandsRoom {
        cell.pushBrandObserver = pushBrandObserver
        cell.pushCategoryObserver = pushCategoryObserver
        cell.pushAllBrandsObserver = pushAllBrandsObserver
        cell.style = .gray
        cell.setup(with: model.brands, withShowAll: (model.component?.link != ""))
        
        return cell
    }
    
    func getNewsRoom(model: HomeComponentModel,
                     cell: NewsRoom) -> NewsRoom {
        cell.setup(with: model.news?.blogs ?? [])
        cell.pushBlogObserver = pushBlogObserver
        cell.seeAllButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushAllNews()
        }
        return cell
    }
    
    func getDotPictureRoom(model: HomeComponentModel,
                           cell: DotPictureRoom) -> DotPictureRoom {
        cell.setup(with: model.component?.content)
        cell.productHelper = productHelper
        return cell
    }
    
    func getHeader(model: ComponentModel?,
                   cell: ComponentHeader,
                   componentType: HomeRoomType) -> ComponentHeader {
        cell.setup(with: model)
        cell.responder.headerObserver = pushHeaderObserver
        cell.responder.style = .white
        cell.responder.bottomEdge = componentType.headerBottomEdge
        return cell
    }
    
}
// Scroll View
extension HomePage {
    func tableScrolling() {
        dotPictureRoom?.tableScrolling()
    }
}
