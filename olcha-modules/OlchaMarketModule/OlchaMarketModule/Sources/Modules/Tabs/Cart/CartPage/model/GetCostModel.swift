
import Foundation

struct GetCostModel: Codable {
    var order: GetCostData?
}

struct GetCostData : Codable {
    var installment_total_sum: Int?
    var first_fee_sum: Int?
    var discount_total: Int?
    var total_cost: Int?
    var payment_of_commission: Double?
    var total_amount: Int?
    var delivery_price: Int?
    
    var coupon_value: Int?
    var products_total_price: Int?
    var bonus_value: Int?
    
    private enum CodingKeys: String, CodingKey {
        case installment_total_sum
        case first_fee_sum
        case discount_total
        case total_cost
        case payment_of_commission
        case total_amount
        case delivery_price
        case coupon_value
        case products_total_price
        case bonus_value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        installment_total_sum = try container.decode(Int?.self, forKey: .installment_total_sum)
        first_fee_sum = try container.decode(Int?.self, forKey: .first_fee_sum)
        discount_total = try container.decode(Int?.self, forKey: .discount_total)
        total_cost = try container.decode(Int?.self, forKey: .total_cost)
        do {
            payment_of_commission = try container.decode(Double?.self, forKey: .payment_of_commission)
        } catch {
            let newValue = try container.decode(Int?.self, forKey: .payment_of_commission)
            payment_of_commission = newValue?.double ?? 0.0
        }
        
        total_amount = try container.decode(Int?.self, forKey: .total_amount)
        delivery_price = try container.decode(Int?.self, forKey: .delivery_price)
        coupon_value = try container.decode(Int?.self, forKey: .coupon_value)
        products_total_price = try container.decode(Int?.self, forKey: .products_total_price)
        
        do {
            bonus_value = try container.decode(Int?.self, forKey: .bonus_value)
        } catch {
            bonus_value = 0
        }
    }
    
}

struct AvaialableProduct: Codable {
    var id: Int?
    var qty: Int?
}
