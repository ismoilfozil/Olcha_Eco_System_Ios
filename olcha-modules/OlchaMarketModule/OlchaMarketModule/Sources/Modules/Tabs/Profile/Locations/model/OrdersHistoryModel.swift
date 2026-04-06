//
//  OrdersHistoryModel.swift
//  NewOlcha
//
//  Created by Muhammadjon on 6/13/21.
//

import Foundation
import OlchaCore
struct OrdersHistoryModel : Codable {
    var message: String?
    var status: String?
    var data: OrdersHistoryData?
}

struct OrdersHistoryData : Codable {
    var orders: [Order]?
    var paginator: Paginator?
}

struct OrderData: Codable {
    var orders: Order?
    var order: Order?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.orders = try container.decodeIfPresent(Order.self, forKey: .orders)
        } catch {}

        do {
            self.order = try container.decodeIfPresent(Order.self, forKey: .order)
        } catch {}
    }
    
}

