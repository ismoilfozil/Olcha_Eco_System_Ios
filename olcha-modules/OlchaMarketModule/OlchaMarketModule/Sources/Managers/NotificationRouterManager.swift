//
//  NotificationRouterManager.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/11/22.
//

import UIKit

public enum NotificationAction: String {
    case product = "OPEN_PRODUCT_VIEW"
    case other = "OTHER"
    case installmentPayment = "INSTALLMENT_PAYMENT"
    case orderStatus = "ORDER_STATUS_UPDATE"
    case catalog = "OPEN_CATALOG_VIEW"
    case brand = "OPEN_BRAND_VIEW"
    case link = "OPEN_LINK_VIEW"
    case productsList = "PRODUCT_LIST"
    case ramadanPraying = "OPEN_RAMADAN_VIEW"
}

public enum NotificationRoute {
    case product(ProductModel?)
    case other
    case installmentPayment(link: String)
    case orderStatus(order: Order?)
    case link(url: String?)
    case catalog(category: CategoryModel?)
    case brand(brand: Manufacturer?)
    case ramadan
    case productsList(filters: ProductListFilters)
    case none
}

public class NotificationRouterManager {
    
    public static let shared = NotificationRouterManager()
    
    public func route(data: CloudMessagingData?) -> NotificationRoute {
        let action = NotificationAction(rawValue: data?.click_action ?? "")
        
        switch action {
        case .product:
            let product = Funcs.getProductModel(id: data?.product_id?.int ?? 0,
                                                name_ru: "",
                                                name_oz: "",
                                                name_uz: "")
            return .product(product)
        case .other:
            return .other
        case .installmentPayment:
            let payment = data?.payment_link ?? ""
            return .installmentPayment(link: payment)
        case .orderStatus:
            let order = Funcs.getOrder(id: data?.order_id)
            return .orderStatus(order: order)
        case .link:
            return .link(url: data?.link)
        case .catalog:
            let category = Funcs.getCategoryModel(id: data?.category_id?.int ?? 0, name_ru: data?.name_ru, name_uz: data?.name_uz, name_oz: data?.name_oz)
            return .catalog(category: category)
        case .brand:
            let brand = Funcs.getManufacturer(id: data?.brand_id?.int ?? 0, name_ru: data?.name_ru, name_uz: data?.name_uz, name_oz: data?.name_oz)
            return .brand(brand: brand)
        case .productsList:
            let filters = ProductListFilters()
            filters.route = data?.link ?? ""
            return .productsList(filters: filters)
        case .ramadanPraying:
            return .ramadan
        case .none:
            return .none
        
        }
        
    }
}
