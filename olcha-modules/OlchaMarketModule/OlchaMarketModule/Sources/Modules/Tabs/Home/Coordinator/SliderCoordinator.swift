//
//  SliderCoordinator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/08/22.
//

import OlchaUI
import UIKit
public protocol SliderCoordinatorProtocol: Coordinator {
    func pushSlider(_ slider: Slider?)
}
public class SliderCoordinator: OlchaMainCoordinator, SliderCoordinatorProtocol {
    
    public override func start() {}
    
    public func pushSlider(_ slider: Slider?) {
        guard let slider = slider,
              let type = SliderPushType(rawValue: slider.type ?? "")
        else {
            return
        }

        switch type {
        case .product:
            let id = slider.typealias?.int
            let alias = Funcs.productAlias(from: slider.route)
            let product: ProductModel = Funcs.getProductModel(id: id)
            productCoordinator.pushProductPage(product: product)

        case .category:
            guard let id = slider.typealias?.int else { return }
            let category = Funcs.getCategoryModel(id: id,
                                                  name_ru: slider.title_ru ?? "",
                                                  name_uz: slider.title_uz ?? "",
                                                  name_oz: slider.title_en ?? "")
            let filters = ProductListFilters()
            filters.category = category
            filters.selectedSort = slider.getSortType()
            catalogCoordinator.pushProductsList(filters: filters)

        case .manufacturer:
            guard let id = slider.typealias?.int else { return }
            let manufacturer = Funcs.getManufacturer(id: id,
                                                     name_ru: slider.title_ru ?? "",
                                                     name_uz: slider.title_uz ?? "",
                                                     name_oz: slider.title_en ?? "")
            let filters = ProductListFilters().setStaticManufacturer(manufacturer)
            filters.selectedSort = slider.getSortType()
            brandsCoordinator.pushBrandProducts(filters: filters)
        case .store:
            guard let id = slider.typealias?.int else { return }
            let filters = ProductListFilters()
            filters.stores = [Store(id: id,
                                    name: slider.title,
                                    name_ru: slider.title_ru,
                                    name_uz: slider.title_uz,
                                    name_oz: slider.title_oz)]
            filters.selectedSort = slider.getSortType()
            catalogCoordinator.pushProductsList(filters: filters)
            break
        case .installments:
            let filters = ProductListFilters()
            filters.productsType = .has_installment
            filters.selectedSort = slider.getSortType()
            catalogCoordinator.pushProductsList(filters: filters)
            
        case .discounts:
            let filters = ProductListFilters()
            filters.productsType = .has_discount
            filters.selectedSort = slider.getSortType()
            catalogCoordinator.pushProductsList(filters: filters)
            break
            
        case .web_page:
//            let vc = WebPage()
//            vc.urlString = slider.getURL()
//            navigationController.push(vc)
            navigationController.openSafari(urlString: slider.getURL())
            break
        case .page:
            switch slider.getTypeAlias() {
            case .search:
                searchCoordinator.pushSearchPage(query: slider.getSearchQuery())
                break
            default:
                pushHtmlPage(url: slider.typealias ?? "")
                break
            }
        case .product_list:
            let filters = ProductListFilters()
            filters.route = slider.route ?? ""
            filters.selectedSort = slider.getSortType()
            catalogCoordinator.pushProductsList(filters: filters)
            break
        case .none: break
        }
        
    }
    
    public func pushHtmlPage(url: String) {
        let vc = HtmlPage()
        vc.url = url
        navigationController.push(vc)
    }
}
