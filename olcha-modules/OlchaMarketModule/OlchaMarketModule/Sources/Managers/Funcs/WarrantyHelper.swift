//
//  WarrantyHelper.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/03/23.
//

import Foundation
class WarrantyHelper {
    static func getWarrantyTitle(_ product: ProductModel?) -> String {
        guard let warrantyType = WarrantyType(rawValue: product?.warranty_type ?? "") else { return "" }
        return getTitle(type: warrantyType, value: product?.warranty ?? 0)
    }
    
    static func isWarrantyEnabled(_ product: ProductModel?) -> Bool {
        (product?.warranty ?? 0) > 0
    }
    
    static func getWarrantyTitle(_ product: StoreProductsData?) -> String {
        guard let warrantyType = WarrantyType(rawValue: product?.warranty_type ?? "") else { return "" }
        return getTitle(type: warrantyType, value: product?.warranty ?? 0)
    }
    
    static func isWarrantyEnabled(_ product: StoreProductsData?) -> Bool {
        (product?.warranty ?? 0) > 0
    }
    
    static private func getTitle(type: WarrantyType, value: Int) -> String {
        let warrantyTitle = "warranty_title".localized() + " "
        switch type {
        case .year:
            return warrantyTitle + " (" + "year".localized() + "): " + value.string
        case .month:
            return warrantyTitle + " (" + "month".localized() + "): " + value.string
        case .day:
            return warrantyTitle + " (" + "day".localized() + "): " + value.string
        }
    }
    
}

enum WarrantyType: String {
    case year
    case month
    case day
}
