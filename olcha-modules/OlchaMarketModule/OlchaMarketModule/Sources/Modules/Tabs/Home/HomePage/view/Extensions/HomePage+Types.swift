//
//  Home.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/08/22.
//

import UIKit

public enum HomeOpenType: String {
    case product = "product"
    case productList = "product_list"
    case categorList = "category_list"
    case category = "category"
    case brandsList = "brands-list"
    case store = "store"
    case none
}

public enum HomeRoomType: String {
    case verticalProducts = "vertical_products"
    case horizontalGridCategories = "horizontal_grid_categories"
    case brands = "brands"
    case news = "news"
    case horizontalProducts = "horizontal_products"
    case dotsPicture = "dots_picture"
    case groupedProducts = "grouped_products"
    case none
    
    var withHeader: Bool {
        switch self {
        case .verticalProducts:
            return true
        case .horizontalGridCategories:
            return true
        case .horizontalProducts:
            return true
        case .groupedProducts:
            return true
        default:
            return false
        }
    }
    
    var headerBottomEdge: CGFloat {
        switch self {
        case .horizontalProducts, .groupedProducts:
            return 0
        default:
            return 16
        }
    }
}

public enum HomeSection {
    
    
    case mainBanner
    case categories
    case dailyProducts
    case gridBanners
    case builder(componentType: String)
    case products
    
    var index: Int {
        switch self {
        case .mainBanner: return 0
        case .categories: return 1
        case .dailyProducts: return 2
        case .gridBanners: return 3
        case .builder: return 4
        case .products: return 1
        }
    }
    
    var height : CGFloat {
        switch self {
            ///16 + 16 
        case .gridBanners: return (Constants.screenWidth - HomeLayoutManager.discountBannersEdge * 2) / 3
//        case .builder(let componentType):
//
//            switch HomeRoomType(rawValue: componentType) {
//            case .brands:
//                return 700
//            case .dotsPicture:
//                return UIScreen.width
//            case .groupedProducts:
//                return 650
//            case .horizontalGridCategories:
//                return 374
//            case .horizontalProducts:
//                return 332
//            case .news:
//                return UITableView.automaticDimension
//            case .verticalProducts:
//                return UITableView.automaticDimension
//            default:
//                return UITableView.automaticDimension
//            }
            
        default: return UITableView.automaticDimension
        }
    }
    
    var footer: CGFloat {
        switch self {
        case .dailyProducts:
            return 12.0
        case .gridBanners:
            return 24
        case .builder:
            return 16
        default: return 0
        }
    }
}

public enum SliderPushType: String {
    case product = "product"
    case category = "category"
    case manufacturer = "manufacturer"
    case installments = "installments"
    case discounts = "discounts"
    case store = "store"
    case page = "page"
    case product_list = "product_list"
    case web_page = "web_page"
    case none
}

public enum SliderTypeAlias: String {
    case search = "search"
    case none
}
