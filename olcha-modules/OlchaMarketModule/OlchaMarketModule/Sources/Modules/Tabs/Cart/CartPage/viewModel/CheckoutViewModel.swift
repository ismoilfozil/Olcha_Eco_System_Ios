//
//  CheckoutViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/07/22.
//
import OlchaAuth
import Foundation
import Combine
import OlchaUI
import OlchaBalance
import OlchaCore
import OlchaUtils

public class CheckoutViewModel: OldBaseViewModel {
    
    @Published var cartProducts: LoadingState<[ProductModel], Never> = .standart
    @Published var orderedSuccessFully = false
    @Published var shippingTypes : [Delivery] = []
    @Published var paymentTypes: PaymentTypeData?
    @Published var coupon: LoadingState<Coupon, Coupon> = .standart
    @Published var getCost: GetCostData?
    
    @Published var bonus: Bonus?
    
    @Published var orderLoading: Bool = false
    @Published var orderFinished: (CheckoutOrdered?, GetCostRequest)?
    @Published var orderError: String?
    @Published var paymentsBalance: Bool = false
    
    var simpleBuyIndicator = CurrentValueSubject<Bool, Never>(false)

    @Published var externalProviders: [ExternalInstallmentProvider] = []
    let externalProvidersLoading = CurrentValueSubject<Bool, Never>(false)

    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    func simpleBuy(productID: Int, type: SimpleBuyModalPage.BuyType, phone: String) {
        let requestBody = SimpleBuyRequest(order_type: type.rawValue,
                                           phone_number: phone,
                                           products: [.init(product_id: productID)])
        let api: CheckoutAPI = .simpleBuy(model: requestBody)
        self.startRequesting(api: api,
                             indicator: self.simpleBuyIndicator) { [weak self] (data: EmptyData?) in
            guard let self else { return }
            self.orderedSuccessFully = true
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.orderedSuccessFully = false
            self.show(error: message)
        }
    }
    
    func loadCartProducts(cartItems: [CartItem]) {
        cartProducts = .loading
        guard !cartItems.isEmpty else { cartProducts = .success([]); return }
        
        let api: CheckoutAPI = .storesProducts(model: .init(products: cartItems))
        self.startRequesting(api: api, isCancellable: true) { [weak self] (data: ProductsData?) in
            guard let self = self else { return }
            self.cartProducts = .success(data?.products)
        }
    }
    
    func loadShippingTypes(districtID: Int?, products: [  [String: Int]  ]) {
        guard let districtID = districtID else { return }
        let api: CheckoutAPI = .shippingTypes(districtID: districtID, products: products)
        self.startRequesting(api: api, isCancellable: true) { [weak self] (data: ShipTypeData?) in
            guard let self = self else { return }
            self.shippingTypes = data?.deliveries ?? []
        }
    }
    
    func loadPaymentTypes(regionID: Int?, withoutBalance: Bool = false) {
        guard let regionID = regionID else { return }
        let api: CheckoutAPI = .paymentTypes(regionID: regionID, withoutBalance: withoutBalance)
        self.startRequesting(api: api, isCancellable: true) { [weak self] (data: PaymentTypeData?) in
            guard let self = self else { return }
            self.paymentTypes = data
        }
    }
    
    func loadBonus() {
        guard AuthGlobalDefaults.isUser() else { return }
        let api: CheckoutAPI = .bonus
        self.startRequesting(api: api) { [weak self] (data: Bonus?) in
            guard let self = self else { return }
            let updatingBonus = data
            updatingBonus?.usingBonus = updatingBonus?.getMaximumBonus().string ?? "0"
            self.bonus = updatingBonus
        }
    }
    
    func getCost(model: GetCostRequest) {
        let api: CheckoutAPI = .getCost(model: model)
        self.startRequesting(api: api) { [weak self] (data: GetCostModel?) in
            guard let self = self else { return }
            self.getCost = data?.order
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
        }
    }
    
    func order(model: GetCostRequest) {
        orderLoading = true
        let api: CheckoutAPI = .order(model: model)
        self.startRequesting(api: api) { [weak self] (data: CheckoutOrdered?) in
            guard let self = self else { return }
            self.orderLoading = false
            self.orderFinished = (data, model)
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.orderError = message
            self.orderLoading = false
        }
    }
    
    func checkCoupon(coupon: String) {
        self.coupon = .loading
        let api: CheckoutAPI = .checkCoupon(model: .init(coupon: coupon))
        self.startRequesting(api: api, isCancellable: true, centerLoader: false) { [weak self] (data: Coupon?) in
            guard let self = self else { return }
            self.coupon = .success(data)
        } onError: { [weak self] message in
            guard let self = self else { return }
            emptyCoupon(message: message)
        }
    }
    
    func emptyCoupon(message: String? = nil) {
        coupon = .failure(
            .init(message: message ?? "",
                  code: nil,
                  value: nil,
                  type: nil,
                  apply_discount: nil)
        )
    }
    
    func loadBalance(from payments: Payments?) {
        guard payments?.balance_alias != "" else { return }
        let loadingPayments = payments

        let api: CheckoutAPI = .loadPaymentsBalance(url: loadingPayments?.balance_alias ?? "")
        
        self.startRequesting(api: api) { [weak self] (data: BalancesData?) in
            guard let self = self else { return }
            loadingPayments?.balance = data?.platformBalance
            self.paymentsBalance = true
        }
    }

    func loadExternalProviders() {
        let api: CheckoutAPI = .externalInstallmentProviders
        startRequesting(api: api, indicator: externalProvidersLoading) { [weak self] (data: ExternalProvidersResponse?) in
            guard let self else { return }
            self.externalProviders = data?.providers ?? []
        }
    }
}
