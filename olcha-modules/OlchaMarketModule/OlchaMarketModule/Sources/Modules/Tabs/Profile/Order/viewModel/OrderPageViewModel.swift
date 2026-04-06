//
//  OrderPageViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/10/22.
//

import Foundation
import Combine
import OlchaUI
import OlchaCore
import OlchaAuth

class OrderPageViewModel: OldBaseViewModel {
    
    @Published var ordersHistoryData: OrdersHistoryData?
    @Published var ordersHistoryError: Bool?
    @Published var orderCanceled: Bool = false
    
    @Published var myOrdersIsLoading: Bool = false
    
    @Published var order: Order?
    
    @Published var paymentURLData: PaymentURLData?
    
    let paymentURLRequesting = CurrentValueSubject<Bool, Never>(false)
    
    let orderSearchRequesting = CurrentValueSubject<Bool, Never>(false)
    
    let paymentSuccess = PassthroughSubject<Bool, Never>()
    
    @Published var orderReturnSearch: LoadingState<OrderData, BaseErrorType> = .standart
    @Published var orderReturn: LoadingState<EmptyData, BaseErrorType> = .standart
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    
    func cancelOrder(id: Int, cause: String) {
        let api: OrderAPI = .cancelOrder(model: .init(id: id, text: cause))
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: EmptyData?) in
            guard let self = self else { return }
            self.orderCanceled = true
        }
    }
    
    func loadOrder(orderID: Int?) {
        guard let orderID = orderID else { return }
        let api: OrderAPI = .order(orderID: orderID)
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: OrderData?) in
            guard let self = self else { return }
            self.order = data?.orders
        }
    }
    
    func searchReturnOrder(orderID: Int?) {
        guard let orderID else { return }
        orderReturnSearch = .loading
        let api: OrderAPI = .searchReturnOrder(orderID: orderID)
       
        self.startRequesting(api: api) { [weak self] data in
            guard let self else { return }
            orderReturnSearch = .success(data)
        } onError: { [weak self] error in
            guard let self else { return }
            orderReturnSearch = .failure(.init(message: error))
        }
    }
    
    func returnOrder(model: ReturnOrderModel) {
        orderReturn = .loading
        
        let api: OrderAPI = .returnOrder(model: model)
        self.startRequesting(api: api) { [weak self] data in
            guard let self else { return }
            orderReturn = .success(data)
        } onError: { [weak self] error in
            guard let self else { return }
            orderReturn = .failure(.init(message: error))
        }

    }
    
    func loadMyOrders(page: Int, status: MyOrdersSortItem) {
        let centerLoadedState = (page == 1)
        if centerLoadedState {
            myOrdersIsLoading = true
        }
        let api: OrderAPI = .myOrders(page: page, status: status)
        
        self.startRequesting(api: api, isCancellable: true, centerLoader: centerLoadedState) { [weak self] (data: OrdersHistoryData?) in
            guard let self = self else { return }
            self.myOrdersIsLoading = false
            self.ordersHistoryData = data
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.myOrdersIsLoading = false
            self.show(error: message)
            self.ordersHistoryError = true
        }
    }
    
    func loadOrderPaymentURL(orderID: Int?) {
        guard let orderID = orderID else { return }
        let api: OrderAPI = .orderPaymentURL(orderID: orderID)
        
        self.startRequesting(api: api, indicator: paymentURLRequesting) { [weak self] (data: PaymentURLData?) in
            guard let self = self else { return }
            self.paymentURLData = data
        }
    }
    
    func balancePay(amount: String?, order_id: Int?) {
        guard let amount = amount,
              let orderID = order_id,
              amount.isNumber else { return }
        let api: OrderAPI = .balancePay(model: .init(amount: amount.int, order_id: orderID))
        
        self.startRequestingWithErrors(api: api, indicator: paymentURLRequesting) { [weak self] (data: EmptyData?) in
            guard let self = self else { return }
            self.show(success: "payment_success".localized())
            self.paymentSuccess.send(true)
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
        } onErrors: { [weak self] (data: CardPaymentErrors?) in
            guard let self = self else { return }
            
            if let message = data?.amount?.first, message != "" {
                self.show(error: message)
            } else if let message = data?.order_id?.first, message != "" {
                self.show(error: message)
            }
            
            
        }

    }
    
    func cardPay(amount: String?, card_id: Int?, orderID: Int?) {
        guard let amount = amount, let card_id = card_id, let orderID = orderID else {
            return
        }
        
        let api: OrderAPI = .orderCardPay(model: .init(amount: amount,
                                                       card_id: card_id,
                                                       id: orderID.string))

        self.startRequesting(api: api, indicator: paymentURLRequesting) { [weak self] (data: EmptyData?) in
            guard let self = self else { return }
            self.show(success: "payment_success".localized())
        }
    }
    
    func loadInstallmentPaymentURL(orderID: Int?, payment: String?, paymentType: String?) {
        guard let orderID = orderID,
              let payment = payment,
              let paymentType = paymentType else { return }
        
        let api: OrderAPI = .installmentPaymentURL(
            model: .init(payment: payment,
                         payment_type: paymentType,
                         order_id: orderID)
        )
        
        self.startRequesting(api: api, indicator: paymentURLRequesting) { [weak self] (data: PaymentURLData?) in
            guard let self = self else { return }
            self.paymentURLData = data
        }
    }
    
    func searchOrder(phone: String, orderID: String) {
        let api: OrderAPI = .search(
            model: .init(
                phone: phone,
                id: orderID
            )   
        )
        
        self.startRequesting(api: api, indicator: orderSearchRequesting) { [weak self] (data: Order?) in
            guard let self = self else { return }
            self.order = data
        }
    }
}
