//
//  Deeplink.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/11/22.
//

import Foundation
import OlchaAuth
enum DeeplinkType {
    case product(model: ProductModel?)
    case category(model: CategoryModel?)
    case brand(model: Manufacturer?, category: CategoryModel?)
    case products(filter: ProductListFilters)
    case referal
    case link(url: String)
    case none
}

class DeeplinkEditor {
    static func checkDeeplinkType(urlString: String?) -> DeeplinkType {
        guard let urlString = urlString else { return .none }
        if urlString.contains("product/view/") {
            if let route = urlString.components(separatedBy: "product/view/").last {
                let product = Funcs.getProductModel(
                    id: route.isNumber ? route.int : nil,
                    alias: route.isNumber ? nil : route)
                return .product(model: product)
            }
        }
        
        if urlString.contains("user/referal/") {
            if let route = urlString.components(separatedBy: "user/referal/").last {
                AuthGlobalDefaults.referral_id = route
                return .referal
            }
        }
        
        if urlString.contains("category/") {
            if let route = URL(string: urlString)?.pathComponents.last {
                let category = Funcs.getCategoryModel(alias: route)
                return .category(model: category)
            }
        }
        
        if urlString.contains("manufacturer/") {
            
            ///https://olcha.uz/ru/manufacturer/samsung/noutbuki
            if let components = URL(string: urlString)?.pathComponents,
                ///https://olcha.uz/ru/manufacturer/samsung/noutbuki  ->
                ///[https://olcha.uz/ru/manufacturer/, samsung/noutbuki]
                ///[samsung, noutbuki]
                ///[samsung]
               let manufacturerAlias = urlString.components(separatedBy: "manufacturer/").last?.components(separatedBy: "/").first,
               ///https://olcha.uz/ru/manufacturer/samsung/noutbuki
               ///[noutbuki]
               let categoryAlias = components.last {
                
                let manufacturer = Funcs.getManufacturer(slug: manufacturerAlias)
                var category: CategoryModel?
                
                if manufacturerAlias != categoryAlias {
                    category = Funcs.getCategoryModel(alias: categoryAlias)
                }
                
                return .brand(model: manufacturer, category: category)
            }
        }
        
        ///https://olcha.uz/oz/installments
        if urlString.contains("/installments") {
            let filters = ProductListFilters()
            filters.productsType = .has_installment
            return .products(filter: filters)
        }
        
        ///https://olcha.uz/oz/giveaway
        ///https://olcha.uz/oz/page/sitemap
        let urls: [String] = ["/giveaway", "/page/sitemap"]
        for url in urls {
            guard urlString.contains(url) else {
                continue
            }
            Funcs.openSafari(urlString: urlString)
        }
        
        if urlString.contains("olcha.uz/"), let url = URL(string: urlString) {
            let filter = ProductListFilters()
            filter.queryRoute = url.path
            return .products(filter: filter)
        }
        
        return .none
    }
    
    
}
extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

