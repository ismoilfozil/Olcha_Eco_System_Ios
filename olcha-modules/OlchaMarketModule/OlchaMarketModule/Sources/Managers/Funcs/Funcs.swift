//
//  Funcs.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/07/22.
//

import UIKit
import AVFoundation

var hasSafeArea: Bool {
    guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
        return false
    }
    return true
}

public class Funcs {
    
    static func getCombination(
        from combinations: [String: Combination],
        variations: [GetVariationData],
        currentID: Int,
        maskCombinations: [Int: Int]
    ) -> CombinationState {
        
        var newCombination: [Int: Int] = maskCombinations
        
        for combination in maskCombinations {
            /// -1 is the value of X element which is being checked
            if combination.value == -1 {
                newCombination[combination.key] = currentID
            }
        }
        
        var combinationId = ""
        
        for variation in variations {
            if let id = variation.id {
                if let featureID = newCombination[id] {
                    combinationId += "\(featureID)."
                }
            }
        }
        if combinationId.last != nil {
            combinationId.removeLast()
        }
        if let combination = combinations[combinationId] {
            let status = (combination.status ?? 0) == 1
            return (status) ? .enabled : .none
        } else {
            let countStatus = newCombination.count < variations.count
            return countStatus ? .none : .disabled
        }
    }
    
    ///ProductReviewItem Height
//    static func calculateCommentCell(width: CGFloat,
//                                     comment: Comment?) -> CGFloat {
//        
//        
//        let text = comment?.review ?? ""
//        let isMediaEmpty = comment?.files?.isEmpty ?? true
//        let isChildEmpty = comment?.child?.isEmpty ?? true
//        
//        let containerTopBottomInset = 32
//        let userImage = 40
//        let userImageReviewTextBottomInset = 12
//        let reviewHeight = (text).height(width: width)
//        let reviewBottomReviewMediaTop = 12
//        let reviewMedia: CGFloat = isMediaEmpty ? 0 : (width * 0.333)
//        let addReviewButton = 32
//        let reviewMediaAddReviewButtonInset = 8
//        let showAllReviews = isChildEmpty ? 0 : 20
//        let showAllReviewsAddReviewButtonInset = 12
//        
//        
//        
//        var totalHeight: CGFloat = 0
//        totalHeight += containerTopBottomInset.cgfloat;
//        totalHeight += userImageReviewTextBottomInset.cgfloat
//        totalHeight += reviewBottomReviewMediaTop.cgfloat
//        totalHeight += userImage.cgfloat
//        totalHeight += reviewMedia
//        totalHeight += addReviewButton.cgfloat
//        totalHeight += reviewMediaAddReviewButtonInset.cgfloat
//        totalHeight += showAllReviews.cgfloat
//        totalHeight += showAllReviewsAddReviewButtonInset.cgfloat
//        
//        totalHeight += reviewHeight
//        
//        
//        return totalHeight
//    }
    
    static func getInstallmentPayment(_ fee: Double,
                                      _ productPrice: Double,
                                      _ firstMonthPrice: Double,
                                      _ month: Int,
                                      _ mr: Double
    ) -> Double {
        
        
        let monthDouble = Double(month)
        
        let rateMonth: Double = (mr / 100) / 12
        
        let resultTop: Double = rateMonth * pow(((1 + rateMonth)), monthDouble)
        
        let resultBottom: Double = pow(((1 + rateMonth)), monthDouble) - 1
        
        let S: Double = productPrice - firstMonthPrice
        
        if resultBottom > 0.0 {
            let result: Double = S * (resultTop) / resultBottom
            
            let roundedResult: Double = (result / 1000).rounded(.up) * 1000
            
            return roundedResult
        } else {
            return 0.0
        }
    }
    
    static func getOldPrice(product: ProductModel?) -> String {
        return product?.max_price?.string.price ?? ""
    }
    
    static func hasDiscount(product: ProductModel?) -> Bool {
        return (product?.discount_price ?? 0) < (product?.max_price ?? 0)
    }
    
    static func hasDiscount(store: StoreProductsData?) -> Bool {
        return (store?.discount_price ?? 0) < (store?.price ?? 0)
    }
    
    static func getOldPrice(store: StoreProductsData?) -> String {
        return store?.price?.string.price ?? ""
    }
    
    static func isAvailableBasket(fullProduct: FullProductData?) -> Bool {
        let product = fullProduct?.product
        let quantity = (product?.quantity ?? "0").int
        let status = product?.status ?? 0
        
        return quantity > 0 && status > 0 && fullProduct != nil
    }
    
    static func isAvailableCredit(fullProduct: FullProductData?) -> Bool {
        let product = fullProduct?.product
        let quantity = (product?.quantity ?? "0").int
        let status = product?.status ?? 0
        
        return Funcs.checkIsPermonthEnabled(product) && (fullProduct != nil) && quantity > 0 && status > 0
    }
    
    static func isAvailableOneClick(fullProduct: FullProductData?) -> Bool {
        let product = fullProduct?.product
        let quantity = (product?.quantity ?? "0").int
        let status = product?.status ?? 0
        
        return fullProduct != nil && quantity > 0 && status > 0
    }
    
    static func checkIsPermonthEnabled(_ product: ProductModel?) -> Bool {
        ((product?.has_installment ?? 0) == 1) && product?.plan != nil
    }
    
    
    static func checkAvailableToBuy(selectedOptions: [Int: Int], combinationOptions: [Int: Int]) -> Bool {
        if combinationOptions.count == 0 { return true }
        return selectedOptions.count > 0
    }
    
    
    static func thumbnailForVideoAtURL(url: URL) -> UIImage? {

        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)

        var time = asset.duration
        time.value = min(time.value, 2)

        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
    
    static func creditMonth(product: ProductModel?) -> Int {
        guard let product = product,
                let plan = product.plan,
              let margin = plan.margin,
              let monthly_repayment = product.monthly_repayment,
              let total_price = product.total_price,
              let max_period = plan.max_period,
              let initial_fee = product.initial_fee
        else {
            return -1
        }
        
        var month = 0
        if (product.initial_fee == 0 && (margin).double < 1) {
            month = max_period.int
        } else if (product.initial_fee != 0) && (margin.double < 1) {
            let monthly = (total_price.int * initial_fee).double / 100
            if (monthly == monthly_repayment.double) {
                month = max_period.int + 1
            }
        }
        return month
        
    }

    
    static func splitCategory(link: String?) -> String {
        let keys = link?.split(separator: "/")
        return String(keys?.last ?? "")
    }
    
    static func getCategoryAlias(category: CategoryModel?) -> String {
        
        let categoryID = category?.id
        let categoryAlias = category?.alias
        
        if let categoryAlias {
            return categoryAlias
        } else if let categoryID, categoryID > 0 {
            return categoryID.string
        }
        
        return ""
    }
    
    static func calculateDiscount(product: ProductModel?) -> Int {
        guard let maxPrice = product?.max_price?.float else { return 0 }
        guard let discountPrice = product?.discount_price?.float else { return 0 }
        
        if (maxPrice != 0 && discountPrice != 0) {
            let per = (maxPrice - discountPrice) * 100 / maxPrice
            return per.rounded(.up).int
        }
        return 0
    }
    
    static func getReferalLink(id: Int?) -> String {
        guard let id = id else { return "" }
        return "https://olcha.uz/user/referal/" + id.string
    }
    
    static func getProductLink(product: ProductModel?) -> String {
        guard let alias = product?.alias else { return "" }
        return "https://olcha.uz/ru/product/view/" + alias
    }
    
//    static func mapper(_ model: UserAddress) -> AddressModel {
//        let address = AddressModel()
//        address.id = model.id
//        address.lat = model.lat
//        address.lng = model.lng
//        address.street = model.street
//        address.house_number = model.house_number
//        address.floor = model.floor
//        address.entrance = model.entrance
//        address.apartment = model.apartment
//        address.street = model.street
//        address.district_id = model.district?.id
//        address.region_id = model.region?.id
//        
//        return address
//    }
    
}
