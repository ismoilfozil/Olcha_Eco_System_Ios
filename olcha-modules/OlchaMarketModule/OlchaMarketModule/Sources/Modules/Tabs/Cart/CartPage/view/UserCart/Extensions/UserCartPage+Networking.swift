//
//  CartPage+Networking+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/10/22.
//

import Foundation
import OlchaAuth

extension UserCartPage {
    func loadShippingTypes() {
        viewModels.checkout.loadShippingTypes(districtID: observers.selectedAddress?.district?.id, products: productsList().0)
    }
    
    func loadPaymentTypes() {
        viewModels.checkout.loadPaymentTypes(regionID: observers.selectedAddress?.region?.id)
    }
    
    func getCost() {
        let productsResult = productsList()
        let products = productsResult.0
        guard !products.isEmpty else { return }
        guard checkButtonState(isGetCost: true) else { return }
        
        viewModels.checkout.getCost(model: getCostRequest(products: products))
    }
    
    func order() {
        let productsResult = productsList()
        let products = productsResult.0
        guard !products.isEmpty else { return }
        
        guard productsResult.1 <= 10 else {
            showError(text: "maximum_limit_10".localized())
            return
        }
        
        if let externalInstallment = observers.credit?.externalInstalment {
            let provider = viewModels.checkout.externalProviders.first {
                $0.checkoutAlias == externalInstallment.alias
            }
            coordinator?.presentExternalInstallmentRequirementModal(
                provider: provider,
                continueAction: { [weak self] in
                    guard let self else { return }
                    self.processOrder(products: products)
                }
            )
            return
        }

        switch observers.selectedBuyType {
        case .credit:
            coordinator?.presentCreditRequirementModal(
                continueAction: { [weak self] in
                    guard let self else { return }
                    self.proceedWithCreditOrder(products: products)
                }
            )
        default:
            processOrder(products: products)
        }
    }
    
    private func proceedWithCreditOrder(products: [[String: Int]]) {
        viewModels.checkout.orderLoading = true
        viewModels.authCredit.verifyCredit { [weak self] in
            guard let self else { return }
            viewModels.checkout.orderLoading = false
            if OlchaGlobalDefaults.isCreditVerified() {
                processOrder(products: products)
            } else {
                coordinator?.presentCartVerification {
                    self.processOrder(products: products)
                }
            }
        }
    }

    private func processOrder(products: [[String : Int]]) {
        checkImportProducts { [weak self] in
            guard let self else { return }
            viewModels.checkout.order(model: getCostRequest(products: products))
        }
    }
    
    
    private func checkImportProducts(completion: (() -> Void)?) {
        let products = observers.products.filter { $0.store?.delivery_location != nil }
        if products.isEmpty {
            completion?()
        } else {
            coordinator?.presentImportProducts(products: products, completion: completion)
        }
    }
    
    private func productsList() -> ([  [String: Int]  ], Int) {
        var productsParams: [  [String: Int]  ] = []
        var totalCount = 0
        for i in 0..<(observers.products.count) {
            let product = observers.products[i]
            let id = (product.id ?? -1)
            let count: Int = product.cart_count ?? 0
            
            let store_id = product.getStoreID() ?? -1
            
            productsParams.append(
                ["id": id,
                 "store_id": store_id,
                 "qty": count]
            )
            
            totalCount += count
        }
        return (productsParams, totalCount)
    }
    
    func screenAppearRequests() {
        placeholderIndicatorWorker()
        CartViewModel.shared.loadCart()
        viewModels.checkout.loadExternalProviders()
        viewModels.checkout.loadBonus()
        viewModels.balance.loadBalance()
        viewModels.locations.loadUserLocations(page: 1)
        updateBalance()
    }
    
    func placeholderIndicatorWorker() {
        if observers.products.isEmpty {
            placeholder.setupIndicator(isLoading: true)
        }
    }
    
    func updateBalance() {
        observers.paymentTypes?.paymentSystems?.forEach { viewModels.checkout.loadBalance(from: $0) }
    }
    
    private func getCostRequest(products:  [[String : Int]]) -> GetCostRequest {
        let orderType: String
        let instPayTime: Int?
        let firstFeeSum: Int?
        let installmentProvider: String?
        let installmentMonths: Int?

        if let ext = observers.credit?.externalInstalment {
            // ext.alias stores checkoutAlias; look up the provider to get the actual alias
            let provider = viewModels.checkout.externalProviders.first {
                $0.checkoutAlias == ext.alias
            }
            orderType = BuyType.credit.rawValue
            instPayTime = ext.period
            firstFeeSum = 0
            installmentProvider = provider?.alias
            installmentMonths = ext.period
        } else {
            orderType = observers.selectedBuyType?.rawValue ?? ""
            instPayTime = observers.credit?.creditDatas[observers.credit?.creditType ?? .olcha]?.inst_pay_time
            firstFeeSum = observers.credit?.creditDatas[observers.credit?.creditType ?? .olcha]?.first_fee_sum
            installmentProvider = nil
            installmentMonths = nil
        }

        return GetCostRequest(
            user_id: AuthGlobalDefaults.user.id,
            products: products,
            name: observers.getName(),
            phone: observers.getPhone(),
            email: nil,
            region_id: observers.selectedAddress?.region?.id,
            district_id: observers.selectedAddress?.district?.id,
            delivery_id: observers.shippingType?.id,
            address_id: observers.selectedAddress?.id,
            street: observers.selectedAddress?.street,
            entrance: observers.selectedAddress?.entrance,
            apartment: observers.selectedAddress?.apartment,
            floor: observers.selectedAddress?.floor,
            house_number: observers.selectedAddress?.house_number,
            payment_type: observers.selectedPayment?.alias,
            comment: observers.comment,
            coupon: observers.coupon?.code,
            first_fee_sum: firstFeeSum,
            inst_pay_time: instPayTime,
            order_type: orderType,
            bonus: observers.isBonusUsing ? (observers.bonus?.usingBonus?.int) ?? 0 : 0,
            installment_provider: installmentProvider,
            installment_months: installmentMonths,
            checkout_type: observers.shippingType?.checkout_type ?? "delivery"
        )
    }
    
    private func isEqual(_ product: ProductModel?, _ cartItem: CartItem?) -> Bool {
        cartItem?.product_id == product?.id && cartItem?.store_id == product?.getStoreID()
    }
    
}
