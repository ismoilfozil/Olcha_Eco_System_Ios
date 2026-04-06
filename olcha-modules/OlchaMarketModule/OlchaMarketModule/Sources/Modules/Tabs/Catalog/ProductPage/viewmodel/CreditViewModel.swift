//
//  CreditStoreRoomViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/07/22.
//

import Foundation
import Combine

class CreditViewModel {
    var withInitialFee = true
    var staticMonth: Int?
    
    var bonus: Double = 0
    var coupon: Double = 0
    
    @Published var monthPayment: Double = 0
    @Published var allPayment: Double = 0
    @Published var productsMonthlyPayments: [String: InstallmentInfo] = [:]
    @Published var initialPayment: Double = 0
    @Published var month = 0
    
    var minMonth: Int = 12
    var maxMonth: Int = 3
    
    @Published var minInitialPayment: Double = 0
    var maxInitialPayment: Double = 0
    
    var maxPayment: Double = 0
    
    private let manager: InstallmentInterface = Installment()
    
    func calculate(products: [ProductModel?]) {
        let newProducts = products.compactMap { $0 }
//        calculatePrices(products: newProducts)
        calculateGraphPrices(products: newProducts)
    }
    
    func calculateStatics(products: [ProductModel?]) {
        let newProducts = products.compactMap { $0 }
        calculateMonths(products: newProducts)
        calculateInitialFees(prodcuts: newProducts)
    }
}
///
/// - `Private functions`
///
fileprivate extension CreditViewModel {
    func calculateGraphPrices(products: [ProductModel]) {
        calculateMonths(products: products)
        //        calculateInitialFees(prodcuts: products)
        //        calculatePrices(products: products)
        let creditProducts = products.map { $0.getCreditProduct() }
        let calculatedValue = manager.monthlyPayment(products: creditProducts,
                                                     initialFee: initialPayment + coupon + bonus,
                                                     totalPrice: getAllTotalPrice(products),
                                                     paymentPeriod: month.double,
                                                     installmentFees: manager.minInitialFee(products: creditProducts))
        
        allPayment = calculatedValue.totalMonthly
        productsMonthlyPayments = calculatedValue.installmentGraph
    }
    
    func calculateMonths(products: [ProductModel]) {
        if let staticMonth = staticMonth {
            month = staticMonth
        } else {
            for product in products {
                if let plan = product.plan {
                    if let minPeriod = plan.min_period?.int,
                       let maxPeriod = plan.max_period?.int {
                        if minMonth > minPeriod {
                            minMonth = minPeriod
                        }
                        
                        if maxMonth < maxPeriod {
                            maxMonth = maxPeriod
                        }
                    }
                }
            }
            month = min(max(month, minMonth), maxMonth)
        }
    }
    
    func calculateInitialFees(prodcuts: [ProductModel]) {
        var minTotalInitialFees: Double = 0
        var maxTotalInitialFees: Double = 0
        
        for product in prodcuts {
            if product.plan != nil {
                
                minTotalInitialFees += ( withInitialFee ? (product.initial_fee?.double ?? 0) : 0) * product.getCreditQuantity()
                maxTotalInitialFees += getTotalPrice(product) * 0.9 * product.getCreditQuantity()
                
            } else {
                minTotalInitialFees += getTotalPrice(product) * product.getCreditQuantity()
                maxTotalInitialFees += getTotalPrice(product) * product.getCreditQuantity()
            }
        }
        
        minInitialPayment = minTotalInitialFees
        maxInitialPayment = maxTotalInitialFees
        initialPayment = minInitialPayment
    }
    
    func calculatePrices(products: [ProductModel]) {
        
        var planTotalPrices: Double = 0
        var allInitialPayments: Double = initialPayment
        products
            .forEach {
                if $0.plan != nil {
                    planTotalPrices += getTotalPrice($0) * $0.getCreditQuantity()
                } else {
                    allInitialPayments -= getTotalPrice($0) * $0.getCreditQuantity()
                }
            }
        var payment: Double = 0
        for product in products {
            if let plan = product.plan {
                let fee = (getTotalPrice(product) / planTotalPrices) * allInitialPayments
                payment += Funcs.getInstallmentPayment((plan.initial_fee?.double ?? 0.0) * product.getCreditQuantity(),
                                                       getTotalPrice(product) * product.getCreditQuantity(),
                                                       fee * product.getCreditQuantity(),
                                                       month,
                                                       plan.margin?.double ?? 0.0).rounded(.up)
            }
        }
        monthPayment = payment
        allPayment = monthPayment * month.double + initialPayment
    }
    
    func getTotalPrice(_ product: ProductModel?) -> Double {
        (product?.total_price ?? "0.0").double
    }
    
    func getAllTotalPrice(_ products: [ProductModel]) -> Double {
        products.reduce(0, { $0 + ($1.total_price?.double ?? 0) })
    }
}

///
/// - `Public functions`
///
extension CreditViewModel {
    func getTrueMonth(month: Int) -> Int {
        return max(minMonth, min(maxMonth, month))
    }
    
    func getTrueInitialPayment(payment: Double) -> Double {
        max(minInitialPayment, min(maxInitialPayment, payment))
    }
}
