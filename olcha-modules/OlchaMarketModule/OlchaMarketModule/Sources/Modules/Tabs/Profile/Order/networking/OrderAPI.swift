//
//  OrderAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/10/22.
//

import Foundation
import OlchaCore
import OlchaUtils
enum OrderAPI: OlchaMarketAPI {
    case myOrders(page: Int, status: MyOrdersSortItem)
    case cancelOrder(model: OrderCancelRequest)
    case order(orderID: Int)
    case orderPaymentURL(orderID: Int)
    case installmentPaymentURL(model: InstallmentPayRequest)
    case orderCardPay(model: OrderCardPayRequest)
    case balancePay(model: BalancePayRequest)
    case search(model: SearchOrderRequest)
    case searchReturnOrder(orderID: Int)
    case returnOrder(model: ReturnOrderModel)
}

extension OrderAPI {
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .myOrders(let page, let status):
            return [
                .init(name: "page", value: "\(page)"),
                .init(name: "status", value: status.key)
            ]
        default: return []
        }
    }
    
    var path: String {
        switch self {
        case .myOrders:
            return "user/orders/all"
        case .cancelOrder:
            return "user/order/canceled"
        case .order(let orderID):
            return "user/order/\(orderID)"
        case .orderPaymentURL(let orderID):
            return "payment/request/\(orderID)"
        case .orderCardPay:
            return "payment/auto-pay"
        case .installmentPaymentURL:
            return "payment/installment/request"
        case .balancePay:
            return "payment/installment/balance"
        case .search:
            return "order/status"
        case .searchReturnOrder(let orderID):
            return "defect-order/\(orderID)"
        case .returnOrder(let model):
            return "defect-order/\(model.orderID ?? 0)"
        }
    }
    
    var version: String {
        switch self {
        case .myOrders: return Texts.url.getVersion(3)
        case .order: return Texts.url.getVersion(3)
        case .cancelOrder: return Texts.url.getVersion(3)
        case .orderPaymentURL: return Texts.url.getVersion(3)
        case .orderCardPay: return Texts.url.getVersion(3)
        case .installmentPaymentURL: return Texts.url.getVersion(3)
        case .balancePay: return Texts.url.getVersion(3)
        case .search: return Texts.url.getVersion(3)
        case .searchReturnOrder: return Texts.url.getVersion(3)
        case .returnOrder: return Texts.url.getVersion(3)
        default: return Texts.url.getVersion(2)
        }
    }
    
    var method: RequestType {
        switch self {
        case .myOrders: return .get
        case .cancelOrder: return .post
        case.order: return .get
        case .orderPaymentURL: return .get
        case .orderCardPay: return .post
        case .installmentPaymentURL: return .post
        case .balancePay: return .post
        case .search: return .post
        case .searchReturnOrder: return .get
        case .returnOrder: return .post
        }
    }
    
    var body: Data? {
        var data: Data?
        switch self {
        case .cancelOrder(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .orderCardPay(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .installmentPaymentURL(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .balancePay(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .search(let model):
            do {
                data = try JSONEncoder().encode(model)
            } catch {}
            break
        case .returnOrder(let model):
            do {
                data = try JSONEncoder().encode(model.dto)
            } catch {}
        default: break
        }
        return data
    }
    
}
