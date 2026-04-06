//
//  CreditCalculatorModels.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 22/02/24.
//

import Foundation

protocol InstallmentCoreProtocol {
    func calculateF(s: Double, r: Double, period: Double) -> Double
    func calculateS(product: CreditProductType, sum: Double) -> Double
    func calculateR(product: CreditProductType) -> Double
    func getPrice(_ product: CreditProductType) -> Double
}

protocol InstallmentGraphProtocol {
    func productFirstFee(product: CreditProductType) -> Double
    func productMonthlyPayment(product: CreditProductType, paymentPeriod: Double) -> Double
}

protocol InstallmentInterface {
    func getTotalPrice(products: [CreditProductType]) -> TotalPrices
    func minInitialFee(products: [CreditProductType]) -> MinInitialFee
    func monthlyPayment(products: [CreditProductType], initialFee: Double, totalPrice: Double, paymentPeriod: Double, installmentFees: MinInitialFee) -> (totalMonthly: Double, installmentGraph: [String: InstallmentInfo])
    func total(monthlyPayment: Double, initialFee: Double, paymentPeriod: Double) -> Double
}

struct InstallmentInfo {
    var product: CreditProductType
    var maxPeriod: Double = 0
    var paymentPerMonth: Double = 0
    var first_fee: Double = 0
    var total_payment: Double = 0
}

struct CreditProductType {
    var id: String
    var plan: CreditProductTypePlan?
    var qty: Double = 0
    var price_group: PriceGroup?
    var total_price: String = "0"
    var initial_fee: Double = 0
}

struct CreditProductTypePlan {
    var margin: Double = 0
    var initial_fee: Double?
    var max_period: Double = 0
}

struct PriceGroup {
    var price: String = "0"
}

struct TotalPrices {
    var total: Double = 0
    var totalWithMargin: Double = 0
    var totalWithoutMargin: Double = 0
}

struct MinInitialFee {
    var installmentFee: Double = 0
    var installmentFeeMax: Double = 0
    var purchaseFee: Double = 0
}
