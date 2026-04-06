//
//  InstallmentDetail.swift
//  NewOlcha
//
//  Created by Muhammadjon on 7/20/21.
//

import Foundation
struct InstallmentDetail : Codable {
    var id: Int?
    var MR: Int?
    var created_at: String?
    var first_fee_sum: Int?
    var first_order: FirstOrder?
    var inst_pay_time: Int?
    var limitation: Int?
    var payments: [InstallmentPayment]?
    var product: InstallmentProduct?
    var status: String?
    
}

struct FirstOrder : Codable {
    var accountant_id: Int?
    var address_id: Int?
    var apartment: String?
    var comment: String?
    var district: District?
    var district_id: Int?
    var installment_id: Int?
    var payment_from_balance: String?
    var payment_of_commission: String?
    var payment_type: String?
    var region: District?
    var region_id: Int?
    var status: String?
    var first_pay: Int?

//    enum CodingKeys: String, CodingKey {
//        
//        case district = "region"
//        case region = "district"
//        
//    }
//    
//    init(from decoder : Decoder) throws  {
//        
//        do {
//             let values = try decoder.container(keyedBy: CodingKeys.self)
//                   do {
//                       self.district = try values.decode(District.self, forKey: .region)
//                   }catch {
//                       
//                   }
//                   
//                   do {
//                       self.region = try values.decode(District.self, forKey: .district)
//                   } catch {
//                       
//                   }
//                   
//                   
//        } catch {
//            print("some exp \(error.localizedDescription)")
//        }
//        
//       
//        
//    }
}

struct InstallmentPayment : Codable {
    var id: Int?
    var history: [PaymentHistory]?
    var instalment_request_id: Int?
    var payment: Int?
    var payment_day: String?
    var status: String?
}

struct PaymentHistory : Codable {
    var contract_id: Int?
    var graph_id: Int?
    var id: Int?
    var payment: Int?
    var payment_day: String?
    var payment_type: String?
    var payment_id: String?
    var status: Int?
}

struct InstallmentResult : Codable {
    var data : [InstallmentResultData]?
    var total_price_all: Int?
    var total_payment_all: Int?
    var total_my_payments_all: Int?
    var id: Int?
}

class InstallmentResultData : Codable {
    var payment_id: Int?
    var actual_payment_date: String?
    var payment_day: String?
    
//    var debt: Int?
    var payment: String?
    var payment_details: String?
    var payment_reason: String?
    var payments: String?
    var status: String?
    var expiry_date: Int?
    var expiry_debt: Int?
    var debt: Int?
    var isExpanded: Bool?
    
    func getTotalPayments() -> Int {
        var paymentItems: [Int] = []
        guard let payments = payments else { return 0 }
        
        return payments
            .replacingOccurrences(of: " ", with: "")
            .components(separatedBy: ",")
            .compactMap { $0.int }
            .reduce(0, +)
    }
    
    private enum CodingKeys: String, CodingKey {
        case payment_id
        case actual_payment_date
        case payment_day
        case payment
        case payment_details
        case payment_reason
        case payments
        case status
        case expiry_date
        case expiry_debt
        case debt
        case isExpanded
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        payment_id = try container.decode(Int.self, forKey: .payment_id)
        actual_payment_date = try container.decode(String.self, forKey: .actual_payment_date)
        payment_day = try container.decode(String.self, forKey: .payment_day)
        do {
            payment = try container.decode(String.self, forKey: .payment)
        } catch DecodingError.typeMismatch {
            let new_payment = try container.decodeIfPresent(Int.self, forKey: .payment)
            payment = new_payment?.string ?? "0"
        }
        
        payment_details = try container.decode(String.self, forKey: .payment_details)
        payment_reason = try container.decode(String.self, forKey: .payment_reason)
        payments = try container.decode(String.self, forKey: .payments)
        status = try container.decode(String.self, forKey: .status)
        expiry_date = try container.decode(Int.self, forKey: .expiry_date)
        
        do {
            expiry_debt = try container.decode(Int.self, forKey: .expiry_debt)
        } catch DecodingError.typeMismatch {
            let new_expiry_debt = try container.decodeIfPresent(String.self, forKey: .expiry_debt)
            expiry_debt = new_expiry_debt?.int ?? 0
        }
        
        
        do {
            debt = try container.decode(Int?.self, forKey: .debt)
        } catch DecodingError.typeMismatch {
            let new_debt = try container.decodeIfPresent(String?.self, forKey: .debt)
            debt = (new_debt ?? "0")?.int ?? 0
        } catch {
            debt = 0
        }
    }
}
struct InstallmentProduct : Codable {
    var id: Int?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var amount: Int?
    var alias: String?
    var main_image: String?
    var images: [String]?
    var MR: Int?
    var price: String?
    
    var name: String?
    func getName() -> String {
        if let name = name {
            return name
        } else {
            return .lang(name_ru,
                         name_uz,
                         name_oz)
        }
    }
}
