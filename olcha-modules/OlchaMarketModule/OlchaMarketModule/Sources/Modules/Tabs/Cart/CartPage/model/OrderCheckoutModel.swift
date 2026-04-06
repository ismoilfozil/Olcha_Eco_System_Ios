//
//  OrderCheckoutModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 6/12/21.
//

import Foundation
import UIKit
public struct OrderCheckoutModel : Codable {
    var message: String?
    var status: String?
    var data: OrderCheckoutData?
    var errors: OrderErrors?
    
}

public struct OrderCheckoutData : Codable {
    var message: String?
    var order: Order?
    var installment_id: Int?
}

public struct CheckoutOrdered : Codable {
    var redirect_url: String?
    var order_id: Int?
}

public class Order : Codable {
    var id: Int?
    var name: String?
    var lastname: String?
    var total_cost: Int?
    var full_address: String?
    var phone: String?
    var district: District?
    var region: District?
    var payment_of_commission: Int?
    var products: [ProductModel]?
    var created_at: String?
    var status: String?
    var status_name: String?
    var has_anorbank_transaction: Bool?
    var installment: InstallmentData?
    var qrcode: String?
    
    var is_installment: Bool?
    var first_order: StatusOrder?
    var is_paid: Bool?
   
    var graphs: [InstallmentResultData]?
    
    var statuses: [OrderStatusItem]?
    var payment_type: String?
    var can_cancel: Bool?
    
    var order_history: [OrderStatus]?
    
    var order_status_title: String?

    var total_price_all: Double?

    var delivery_code: String?
    
    public init(id: Int?) {
        self.id = id
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try container.decode(Int?.self, forKey: .id)
        }
        
        do {
            name = try container.decode(String?.self, forKey: .name)
        } catch {
            
        }
        
        do {
            payment_type = try container.decode(String?.self, forKey: .payment_type)
        } catch {
            
        }
        
        do {
            lastname = try container.decode(String?.self, forKey: .lastname)
        } catch {
            
        }
        
        do {
            total_cost = try container.decode(Int?.self, forKey: .total_cost)
        } catch {
            
        }
        
        do {
            full_address = try container.decode(String?.self, forKey: .full_address)
        } catch {
            
        }
        
        do {
            phone = try container.decode(String?.self, forKey: .phone)
        } catch {
            
        }
        
        do {
            can_cancel = try container.decode(Bool?.self, forKey: .can_cancel)
        } catch {
            
        }
        
        do {
            district = try container.decode(District?.self, forKey: .district)
        } catch {
            
        }
        
        do {
            region = try container.decode(District?.self, forKey: .region)
        } catch {
            
        }
        
        do {
            payment_of_commission = try container.decode(Int?.self, forKey: .payment_of_commission)
        } catch {
            
        }
        
        do {
            products = try container.decode([ProductModel]?.self, forKey: .products)
        } catch {
            
        }
        
        do {
            created_at = try container.decode(String?.self, forKey: .created_at)
        } catch {
            
        }
        
        do {
            status = try container.decode(String?.self, forKey: .status)
        } catch {}
        
        do {
            status_name = try container.decode(String?.self, forKey: .status_name)
        } catch {}
        
        do {
            created_at = try container.decode(String?.self, forKey: .created_at)
        } catch {
            
        }
        
        do {
            has_anorbank_transaction = try container.decode(Bool?.self, forKey: .has_anorbank_transaction)
        } catch {
            
        }
        
        do {
            installment = try container.decode(InstallmentData?.self, forKey: .installment)
        } catch {
            
        }
        
        do {
            is_installment = try container.decode(Bool?.self, forKey: .is_installment)
        } catch {
            
        }
        
        do {
            first_order = try container.decode(StatusOrder?.self, forKey: .first_order)
        } catch {
            
        }
        
        do {
            is_paid = try container.decode(Bool?.self, forKey: .is_paid)
        } catch {
            
        }
        
        do {
            graphs = try container.decode([InstallmentResultData]?.self, forKey: .graphs)
        } catch {
            
        }

        do {
            statuses = try container.decode([OrderStatusItem]?.self, forKey: .statuses)
        } catch {

        }
        
        do {
            qrcode = try container.decode(String?.self, forKey: .qrcode)
        } catch {
            
        }
        
        do {
            order_history = try container.decode([OrderStatus]?.self, forKey: .order_history)
        } catch {}
        
        do {
            order_status_title = try container.decode(String.self, forKey: .order_status_title)
        } catch {}
        do {
            total_price_all = try container.decode(Double.self, forKey: .total_price_all)
        } catch {}
        do {
            delivery_code = try container.decode(String.self, forKey: .delivery_code)
        } catch {}
    }
    
    func getOrderStatusTitle() -> String {
        order_status_title ?? " - "
    }
    
    func getStatusTitle() -> String {
        if let status = first_order?.status_name {
            return status
        } else {
            return status_name ?? ""
        }
    }
    
    func getStatusColor() -> UIColor {
        guard let hexString = first_order?.status_color else { return .olchaAccentColor }
        return UIColor.hex(hexString)
    }
    
    func getStatus() -> MyOrdersSortItem {
        guard let statusString = status,
              let status = MyOrdersSortItem(rawValue: statusString) else {
                  return .none
              }
        return status
    }
    
    func getInstallmentStatus() -> MyOrdersSortItem {
        guard let statusString = first_order?.status,
              let status = MyOrdersSortItem(rawValue: statusString) else {
                  return .none
              }
        return status
    }
    
    func getPaymentType() -> PaymentType {
        guard let paymentString = payment_type,
              let payment = PaymentType(rawValue: paymentString) else {
            return .none
        }
        return payment
    }
    
    func checkInstallmentPayButtonStatus() -> Bool {
        if (is_installment ?? false) {
            let status = getInstallmentStatus()
            
            if status == .finished {
                return false
            } else if ((getStatus() != .in_work &&
                (status == .confirmed || status == .delivered) &&
                (getPaymentType() != .none)) ||
                (getStatus() == .in_work && getInstallmentStatus() == .delivered)) {
                return true
            }
        }
        return false
    }
    
    func checkOrderPayButtonStatus() -> Bool {
        if ((is_installment ?? false) == false)  {
            let status = getStatus()
            if status == .pending && getPaymentType() != .none {
                return true
            }
        }
        return false
    }
    
    func getHistories() -> [OrderStatus] {
        order_history ?? []
    }

    func shouldShowDeliveryCode() -> Bool {
        guard let code = delivery_code, !code.isEmpty else { return false }
        let hiddenStatuses: [String] = ["delivered", "delivered_customer", "canceled"]
        if let rawStatus = status, hiddenStatuses.contains(rawStatus) {
            return false
        }
        if let firstOrderStatus = first_order?.status, hiddenStatuses.contains(firstOrderStatus) {
            return false
        }
        return true
    }
}

public struct StatusOrder: Codable {
    var status: String?
    var status_name: String?
    var payment_type: String?
    var status_color: String?
    
    func getColor() -> UIColor {
        guard let status_color else { return .olchaTextBlack ?? .black }
        return .hex(status_color)
    }
}

public struct OrderProduct : Codable {
    var id: Int?
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var amount: Int?
    var alias: String?
    var main_image: String?
    var images: [String]?
    var MR: Int?
    var price: Int?
    
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

public struct OrderErrors : Codable {
    var name: [String]?
    var district_id: [String]?
    var payment_type: [String]?
    var phone: [String]?
    var region_id: [String]?
    var street: [String]?
    var checkout_type: [String]?
    var pickup_address_id: [String]?
    var pickup_time: [String]?
    var house_number: [String]?
    var entrance: [String]?
}

public struct OrderStatusItem: Codable {
    var status: String?
    var subtitle: String?
    var text: String?
    var active: Bool?
    
    public init(status: String?, subtitle: String?, text: String?, active: Bool?) {
        self.status = status
        self.subtitle = subtitle
        self.text = text
        self.active = active
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case subtitle = "created_at"
        case status
        case text
        case active
    }
    
    func getStatus() -> MyOrdersSortItem {
        if let status = status {
            return MyOrdersSortItem(rawValue: status) ?? .none
        }
        return .none
    }
}

public class OrderStatus: Codable {
    
    var name: String?
    var is_canceled: Bool?
    var active: Bool?
    var created_at: String?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            is_canceled = try container.decode(Bool?.self, forKey: .is_canceled)
        } catch {}
        
        do {
            name = try container.decode(String?.self, forKey: .name)
        } catch {}
        
        do {
            active = try container.decode(Bool?.self, forKey: .active)
        } catch {}
        
        do {
            created_at = try container.decode(String?.self, forKey: .created_at)
        } catch {}
        
    }
}
