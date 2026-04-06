//
//  Product.swift
//  NewOlcha
//
//  Created by Muhammadjon on 1/11/21.
//

import Foundation
import UIKit
import Lottie



//public struct ProductModel : Decodable {
//    var id: Int?
//    var inStock: Bool?
//    var name_ru: String?
//    var name_uz: String?
//    var name_oz: String?
//    var currency: String?
//    var price: String?
//    var alias: String?
//    var manufacturer_id: Int?
//    var category_id: Int?
//
//    var discount: Int?
//    var discount_value: String?
//    var discount_type: String?
//
//    var short_description_ru: String?
//    var short_description_uz: String?
//    var short_description_oz: String?
//
//    var description_ru: String?
//    var description_uz: String?
//    var description_oz: String?
//
//    var shipment_count: String?
//    var rating: Int?
//    var total_price: String? //Int bolishi mn korish kere. QAYTAMAN
//    var images: [String]?
//    var discount_price: Int?
//    var category: CategoryModel?
//    var main_image: String?
//    var plan_id: Int?
//    var has_installment: Int?
//    var monthly_repayment: Int?
//    var manufacturer: Manufacturer?
//    var plan: Plan?
//    var store: Store?
//
//    var mr: Int?
//
//
//
//    var quantity: String?
//    var status: Int?
////    var cashback: String?
//
//    var weight: Int?
//    var warranty_month: Int?
//
//    var recommended: Int?
//    var popular: Int?
//    var new: Int?
//    var sale: Int?
//
//    var product_type: String?
//    var parent_product: Int?
//    var is_main: Int?
////    var max_price: String?
//    var is_like: Bool?
//
//    var initial_fee: Int?
//
//    var is_favorite: Bool?
//
//    var height_name_ru: CGFloat?
//    var height_name_uz: CGFloat?
//    var height_name_oz: CGFloat?
//
//    var height_price: CGFloat?
//
//    var characteristics: String?
//
//
//    //new search data
//    var _index : String?
//    var _id : String?
//    var _score : Double?
//    var _source : SourceProducts?
//
//}


struct Plan : Codable {
    var margin: String?
    var initial_fee: Int?
    var min_period: String?
    var max_period: String?
    var max_scoring: String?
    var min_scoring: String?
    var id: Int?
}




// total_price bir xil joyda string bir xil joyda int kelyapti, shu uchun shunaqa CODABLE qlinyapti

public class ProductModel : Codable, Equatable {
    
    public static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        ((lhs.id ?? -1) == (rhs.id ?? -2)) && (lhs.getStoreID() == rhs.getStoreID()) && (lhs.cart_count == rhs.cart_count) && (lhs.is_like == rhs.is_like)
    }
    
    var id: Int?
    var inStock: Bool?
    var name: String?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var currency: String?
    var price: String?
    var alias: String?
    var manufacturer_id: Int?
    var category_id: Int?
    
    var cashback_percent: Int?
    var short_description_ru: String?
    var short_description_uz: String?
    var short_description_oz: String?
    var short_description: String?
    
    var description_ru: String?
    var description_uz: String?
    var description_oz: String?
    var description: String?
    var amount: Int?
    
    var trimmed_description_ru: String?
    var trimmed_description_uz: String?
    var trimmed_description_oz: String?
    var trimmed_description: String?
    
    var rating: Int?
    var total_price: String? //Int bolishi mn korish kere. QAYTAMAN
    var images: [String]?
    var discount_price: Int?
    var max_price: Int?
    var category: CategoryModel?
    var main_image: String?
    var has_installment: Int?
    var monthly_repayment: Int?
    var manufacturer: Manufacturer?
    var plan: Plan?
    var store: Store?
    var storeProducts: [StoreProductsData]?
    
    var gifts: [ProductModel]?
    var for_adults: Int?
    
    var quantity: String?
    var status: Int?
    var video_url: String?
    
    var warranty: Int?
    var warranty_month: Int?
    var warranty_type: String?

    var is_like: Bool?
    
    var initial_fee: Int?
    
    var store_id: Int?
    
    var cart_count: Int?
    
    var cartSelected: Bool?
    
    var creditQuantity: Int?
    
    var out_of_stock: Bool?
    var is_parent: Int?
    
    var can_comment: Bool?
    
    var qrcode: String?
    
    var is_white: Bool?
    var is_compared: Bool?
    
    var status_color: String?
    var status_description: String?
    var status_name: String?
    
    required public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            total_price = try values.decodeIfPresent(String.self, forKey: .total_price)
        } catch (let err){
            let newTotal_price = try values.decodeIfPresent(Int.self, forKey: .total_price)
            total_price = "\(newTotal_price ?? 0)"
        }

        do {
            price = try values.decodeIfPresent(String.self, forKey: .price)
        } catch (let err){
            let newPrice = try values.decodeIfPresent(Int.self, forKey: .price)
            price = "\(newPrice ?? 0)"
        }


        id = try values.decodeIfPresent(Int.self, forKey: .id )
        inStock = try values.decodeIfPresent(Bool.self, forKey: .inStock)
        for_adults = try values.decodeIfPresent(Int.self, forKey: .for_adults)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        name_ru = try values.decodeIfPresent(String.self, forKey: .name_ru)
        name_uz = try values.decodeIfPresent(String.self, forKey: .name_uz)
        name_oz = try values.decodeIfPresent(String.self, forKey: .name_oz)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        video_url = try values.decodeIfPresent(String.self, forKey: .video_url)
        alias = try values.decodeIfPresent(String.self, forKey: .alias)
        manufacturer_id = try values.decodeIfPresent(Int.self, forKey: .manufacturer_id)
        category_id = try values.decodeIfPresent(Int.self, forKey: .category_id)


        short_description_ru = try values.decodeIfPresent(String.self, forKey: .short_description_ru)
        short_description_uz = try values.decodeIfPresent(String.self, forKey: .short_description_uz)
        short_description_oz = try values.decodeIfPresent(String.self, forKey: .short_description_oz)
        short_description = try values.decodeIfPresent(String.self, forKey: .short_description)
        do {
            description_ru = try values.decodeIfPresent(String.self, forKey: .description_ru)
        } catch {}
        do {
            description_uz = try values.decodeIfPresent(String.self, forKey: .description_uz)
        } catch {}
        do {
            description_oz = try values.decodeIfPresent(String.self, forKey: .description_oz)
        } catch {}
        do {
            description = try values.decodeIfPresent(String.self, forKey: .description)
        } catch {}

        rating = try values.decodeIfPresent(Int.self, forKey: .rating)
        is_parent = try values.decodeIfPresent(Int.self, forKey: .is_parent)
        do {
            amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        } catch {
            amount = 0
        }
        
        
        do {
            is_compared = try values.decodeIfPresent(Bool.self, forKey:  .is_compared)
        } catch { }
        
        do {
            discount_price = try values.decodeIfPresent(Int.self, forKey:  .discount_price)
        } catch { }

        category = try values.decodeIfPresent(CategoryModel.self, forKey: .category)
        main_image = try values.decodeIfPresent(String.self, forKey: .main_image)
        has_installment = try values.decodeIfPresent(Int.self, forKey: .has_installment)
        monthly_repayment = try values.decodeIfPresent(Int.self, forKey: .monthly_repayment)
        manufacturer = try values.decodeIfPresent(Manufacturer.self, forKey: .manufacturer)
        plan = try values.decodeIfPresent(Plan.self, forKey: .plan)
        store = try values.decodeIfPresent(Store.self, forKey: .store)


        do {
            images = try values.decodeIfPresent([String].self, forKey: .images)
        } catch (_){
            let value = try values.decodeIfPresent(String.self, forKey: .images)
            images = [value ?? ""]
        }

        do {
            store_id = try values.decodeIfPresent(Int.self, forKey: .store_id)
        } catch (_){
            let value = try values.decodeIfPresent(String.self, forKey: .store_id)
            store_id = (value?.int ?? 0)
        }

        do {
            quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
        } catch (_){
            let value = try values.decodeIfPresent(Int.self, forKey: .quantity)
            quantity = (value?.string ?? "0")
        }

        out_of_stock = try values.decodeIfPresent(Bool.self, forKey: .out_of_stock)
        status = try values.decodeIfPresent(Int.self, forKey: .status)

        warranty_month = try values.decodeIfPresent(Int.self, forKey: .warranty_month)

        do {
            warranty_type = try values.decodeIfPresent(String.self, forKey: .warranty_type)
        } catch {}

        do {
            warranty = try values.decodeIfPresent(Int.self, forKey: .warranty)
        } catch {}


        is_like = try values.decodeIfPresent(Bool.self, forKey: .is_like)
        initial_fee = try values.decodeIfPresent(Int.self, forKey: .initial_fee)

        storeProducts = try values.decodeIfPresent([StoreProductsData].self, forKey: .storeProducts)
        gifts = try values.decodeIfPresent([ProductModel].self, forKey: .gifts)
        cashback_percent = try values.decodeIfPresent(Int.self, forKey: .cashback_percent)

        do {
            max_price = try values.decodeIfPresent(Int.self, forKey: .max_price)
        } catch (_){
            let new_max_price = try values.decodeIfPresent(String.self, forKey: .max_price)
            max_price = (new_max_price ?? "0").int
        }

        do {
            can_comment = try values.decodeIfPresent(Bool.self, forKey: .can_comment)
        } catch {
            can_comment = false
        }

        do {
            qrcode = try values.decodeIfPresent(String.self, forKey: .qrcode)
        } catch {
            qrcode = ""
        }
        
        do {
            is_white = try values.decodeIfPresent(Bool.self, forKey: .is_white)
        } catch {
            is_white = true
        }

        cart_count = try values.decodeIfPresent(Int.self, forKey: .cart_count)

        
        do {
            status_color = try values.decodeIfPresent(String.self, forKey: .status_color)
        } catch {
            status_color = ""
        }
        do {
            status_description = try values.decodeIfPresent(String.self, forKey: .status_description)
        } catch {
            status_description = ""
        }
        do {
            status_name = try values.decodeIfPresent(String.self, forKey: .status_name)
        } catch {
            status_name = ""
        }
        
    }

    init(id:Int?, inStock:Bool?,
         name:String?,
         name_ru:String?,
         name_oz:String?,
         name_uz:String?,
         currency:String?,
         price:String?,
         alias:String?,
         manufacturer_id:Int?,
         category_id:Int?,
         discount:Int?,
         discount_value:String?,
         discount_type:String?,
         short_description_ru: String?,
         short_description_uz: String?,
         short_description_oz:String?,
         description_ru:String?,
         description_uz:String?,
         description_oz:String?,
         shipment_count:String?,
         rating:Int?,
         total_price:String?,
         images:[String]?,
         discount_price:Int?,
         category:CategoryModel?,
         main_image:String?,
         plan_id:Int?,
         has_installment:Int?,
         monthly_repayment:Int?,
         manufacturer:Manufacturer?,
         plan:Plan?,
         store:Store?,
         mr:Int?,
         quantity:String?,
         status:Int?,
         weight:Int?,
         warranty_month:Int?,
         recommended:Int?,
         popular:Int?,
         new:Int?,
         sale:Int?,
         product_type:String?,
         parent_product:Int?,
         is_main:Int?,
         is_like:Bool?,
         initial_fee:Int?,
         is_favorite:Bool?,
         height_name_ru:CGFloat?,
         height_name_uz:CGFloat?,
         height_name_oz:CGFloat?,
         height_price:CGFloat?,
         characteristics:String?,
         max_price: Int?,
         store_id: Int?
    ) {

        self.store_id = store_id
        self.id = id
        self.name = name
        self.name_ru = name_ru
        self.name_oz = name_oz
        self.name_uz = name_uz
        self.currency = currency
        self.price = price
        self.alias = alias
        self.manufacturer_id = manufacturer_id
        self.category_id = category_id
        self.short_description_ru = short_description_ru
        self.short_description_uz = short_description_uz
        self.short_description_oz = short_description_oz
        self.description_ru = description_ru
        self.description_uz = description_uz
        self.description_oz = description_oz
        self.rating = rating
        self.total_price = total_price
        self.images = images
        self.discount_price = discount_price
        self.category = category
        self.main_image = main_image
        self.has_installment = has_installment
        self.monthly_repayment = monthly_repayment
        self.manufacturer = manufacturer
        self.plan = plan
        self.store = store
        self.quantity = quantity
        self.status = status
        self.warranty_month = warranty_month
        self.is_like = is_like
        self.initial_fee = initial_fee
        self.max_price = max_price

    }
    
    static func mock(id: Int = 0) -> ProductModel {
        return .init(id: id, inStock: false, name: "Смартфон Xiaomi Redmi Note 11 6 GB 128GB Графитово-серый", name_ru: "Смартфон Xiaomi Redmi Note 11 6 GB 128GB Графитово-серый", name_oz: "Смартфон Xiaomi Redmi Note 11 6 GB 128GB Графитово-серый", name_uz: "Смартфон Xiaomi Redmi Note 11 6 GB 128GB Графитово-серый", currency: nil, price: nil, alias: nil, manufacturer_id: nil, category_id: nil, discount: nil, discount_value: nil, discount_type: nil, short_description_ru: nil, short_description_uz: nil, short_description_oz: nil, description_ru: nil, description_uz: nil, description_oz: nil, shipment_count: nil, rating: nil, total_price: nil, images: nil, discount_price: nil, category: nil, main_image: "https://olcha.uz/image/original/products/Bck0PB3fweMXVvTR2BpatruLk5H0dWMUfjZqTPSTAp28vnC5BW10cCQRF7VG.", plan_id: nil, has_installment: nil, monthly_repayment: nil, manufacturer: nil, plan: nil, store: nil, mr: nil, quantity: nil, status: nil, weight: nil, warranty_month: nil, recommended: nil, popular: nil, new: nil, sale: nil, product_type: nil, parent_product: nil, is_main: nil, is_like: nil, initial_fee: nil, is_favorite: nil, height_name_ru: nil, height_name_uz: nil, height_name_oz: nil, height_price: nil, characteristics: nil, max_price: nil, store_id: nil)
    }
    
    func getStoreID() -> Int? {
        if let store = store {
            return store.id
        } else {
            return store_id
        }
    }
    
    func getName() -> String {
        if let name = name {
            return name
        } else {
            return .lang(name_ru, name_uz, name_oz)
        }
    }
    
    
    func getTrimmedDescription() -> String {
        if let trimmed_description = trimmed_description, trimmed_description != "" {
            return trimmed_description.htmlTrimmer
        } else {
            return .lang(trimmed_description_ru,
                         trimmed_description_uz,
                         trimmed_description_oz).htmlTrimmer
        }
    }
    
    func getDescription() -> String {
        if let description = description, description != "" {
            return description
        } else {
            return .lang(description_ru,
                         description_uz,
                         description_oz)
        }
    }
    
    func trimDescription() {
//        trimmed_description = String(htmlEncodedString: description?.htmlTrimmer ?? "")
//        trimmed_description_ru = String(htmlEncodedString: description_ru?.htmlTrimmer ?? "")
//        trimmed_description_uz = String(htmlEncodedString: description_uz?.htmlTrimmer ?? "")
//        trimmed_description_oz = String(htmlEncodedString: description_oz?.htmlTrimmer ?? "")
    }
    
    func getShortDescription() -> String {
        if let short_description = short_description {
            return short_description.htmlTrimmer
        } else {
            return .lang(short_description_ru,
                         short_description_uz,
                         short_description_oz).htmlTrimmer
        }
    }
    
    func isParentProduct() -> Bool {
        (is_parent ?? 0) == 1
    }
    
    func isHtml() -> Bool {
        getShortDescription().isValidHtmlString
    }
    
    func getCreditProduct() -> CreditProductType {
        CreditProductType(id: id?.string ?? "",
                          plan: .init(margin: plan?.margin?.double ?? 0,
                                      initial_fee: plan?.initial_fee?.double ?? 0,
                                      max_period: plan?.max_period?.double ?? 0),
                          qty: getCreditQuantity(),
                          price_group: nil,
                          total_price: total_price ?? "0",
                          initial_fee: initial_fee?.double ?? 0.0)
    }
    
    func getCreditQuantity() -> Double {
        if let quantity = creditQuantity {
            return quantity.double
        } else {
            return (cart_count ?? 1).double
        }
    }
}

