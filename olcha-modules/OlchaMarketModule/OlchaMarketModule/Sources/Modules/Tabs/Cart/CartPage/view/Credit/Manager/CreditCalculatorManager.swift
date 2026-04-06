import Foundation


class InstallmentCore: InstallmentCoreProtocol {
    
    func calculateF(s: Double, r: Double, period: Double) -> Double {
        let top = r * pow(1 + r, period)
        let bottom = pow(1 + r, period) - 1
        if bottom > 0 {
            return s * (top / bottom)
        }
        return 0
    }
    
    func calculateS(product: CreditProductType, sum: Double) -> Double {
        if let plan = product.plan {
            return ceil((getPrice(product) * Double(product.qty) - sum) / 1000) * 1000
        } else {
            return ceil((getPrice(product) * Double(product.qty)) / 1000) * 1000
        }
    }
    
    func calculateR(product: CreditProductType) -> Double {
        return Double(product.plan?.margin ?? 0) / 100 / 12
    }
    
    func getPrice(_ product: CreditProductType) -> Double {
        if let price = product.price_group?.price {
            return Double(price) ?? (Double(product.total_price) ?? 0.0)
        } else {
            return Double(product.total_price) ?? 0.0
        }
    }
}

class InstallmentGraph: InstallmentCore, InstallmentGraphProtocol {
    
    static let shared = InstallmentGraph()
    
    func productFirstFee(product: CreditProductType) -> Double {
        var result: Double = 0
        
        if product.plan == nil {
            result = ceil(getPrice(product) * Double(product.qty) / 1000) * 1000
        } else {
            if let initialFee = product.plan?.initial_fee, initialFee < 1 {
                result = 0
            } else {
                result = ceil((getPrice(product) * Double(product.qty) / 100 * Double(product.plan?.initial_fee ?? 0)) / 1000) * 1000
            }
        }
        
        return result
    }
    
    func productMonthlyPayment(product: CreditProductType, paymentPeriod: Double) -> Double {
        var result: Double = 0
        
        guard let plan = product.plan else {
            return result
        }
        
        let productFirstFee = self.productFirstFee(product: product)
        let r = self.calculateR(product: product)
        let s = self.calculateS(product: product, sum: productFirstFee)
        
        if r == 0 {
            result = round(s / paymentPeriod)
        } else {
            result = ceil(self.calculateF(s: s, r: r, period: paymentPeriod) / 1000) * 1000
        }
        
        return result
    }
}

class Installment: InstallmentCore, InstallmentInterface {
    
    func getTotalPrice(products: [CreditProductType]) -> TotalPrices {
        var total: Double = 0
        var totalWithMargin: Double = 0
        var totalWithoutMargin: Double = 0
        
        for product in products {
            if let plan = product.plan, plan.margin < 1 {
                totalWithoutMargin += getPrice(product) * Double(product.qty)
            } else {
                totalWithMargin += getPrice(product) * Double(product.qty)
            }
            total += getPrice(product) * Double(product.qty)
        }
        
        return TotalPrices(total: total, totalWithMargin: totalWithMargin, totalWithoutMargin: totalWithoutMargin)
    }
    
    func minInitialFee(products: [CreditProductType]) -> MinInitialFee {
        var installmentFeeMin: Double = 0
        var installmentFeeMax: Double = 0
        var purchaseFee: Double = 0
        
        installmentFeeMin = ceil(products.reduce(into: 0.0) { (acc, item) in
            if item.plan == nil {
                purchaseFee += getPrice(item) * Double(item.qty)
                installmentFeeMax += ceil(getPrice(item) * Double(item.qty))
                acc += ceil((getPrice(item) * Double(item.qty)) / 1_000) * 1_000
            } else if let initialFee = item.plan?.initial_fee, initialFee == 0 {
                return
            } else {
                installmentFeeMax += ceil(getPrice(item) * Double(item.qty) * 0.9)
                acc += item.initial_fee * item.qty
            }
        })
        return MinInitialFee(installmentFee: installmentFeeMin, installmentFeeMax: installmentFeeMax, purchaseFee: purchaseFee)
    }
    
    func monthlyPayment(products: [CreditProductType], initialFee: Double, totalPrice: Double, paymentPeriod: Double, installmentFees: MinInitialFee) -> (totalMonthly: Double, installmentGraph: [String: InstallmentInfo]) {
        var installmentGraph: [String: InstallmentInfo] = [:]
        var fee = initialFee
        print("DDD!!!!", fee, totalPrice)
        if fee == totalPrice {
            return (totalMonthly: 0, installmentGraph: installmentGraph)
        }
        
        var feeRemains = fee > installmentFees.installmentFee - installmentFees.purchaseFee ? fee - (installmentFees.installmentFee - installmentFees.purchaseFee) : 0
        
        let sortedProducts = products.sorted { (last, current) -> Bool in
            if last.plan != nil && current.plan == nil {
                return true
            } else if last.plan == nil && current.plan != nil {
                return false
            } else if let lastPlan = last.plan, let currentPlan = current.plan {
                return lastPlan.margin > currentPlan.margin
            } else {
                return getPrice(last) < getPrice(current)
            }
        }
        
        let monthly = sortedProducts.reduce(into: 0.0) { (monthlyTotal, product) in
            if product.plan == nil {
                installmentGraph[product.id] = InstallmentInfo(product: product,
                                                               maxPeriod: paymentPeriod,
                                                               paymentPerMonth: 0,
                                                               first_fee: 0,
                                                               total_payment: 0)
                
                installmentGraph[product.id]?.first_fee = InstallmentGraph.shared.productFirstFee(product: product)
            }
            guard let plan = product.plan else { return }
            let r = calculateR(product: product)
            let percent = InstallmentGraph.shared.productFirstFee(product: product)
            var confSum = percent != nil && fee > 0 ? (fee * (percent / fee)) : percent
            
            var a: Double = 0
            
            if feeRemains > 0 {
                let confSumValue = confSum
                if feeRemains + confSumValue < getPrice(product) {
                    confSum += feeRemains
                    feeRemains -= feeRemains
                } else {
                    a = getPrice(product) - confSum
                    confSum = getPrice(product)
                    feeRemains -= a
                }
            }
            
            installmentGraph[product.id] = InstallmentInfo(product: product,
                                                           maxPeriod: paymentPeriod,
                                                           paymentPerMonth: 0,
                                                           first_fee: 0,
                                                           total_payment: 0)
            
            installmentGraph[product.id]?.first_fee = confSum
            
            var p: Double = 0
            let s = calculateS(product: product, sum: confSum)
            let planMaxPeriod = plan.max_period
            if planMaxPeriod < paymentPeriod && plan.margin < 1 {
                p = ceil(calculateF(s: s, r: r, period: Double(planMaxPeriod)) / 1000) * 1000
                installmentGraph[product.id]?.maxPeriod = planMaxPeriod
                installmentGraph[product.id]?.paymentPerMonth = p
                print("ccccc", "eeee", ceil(0/1000)*1000)
                if let paymentPerMonth = installmentGraph[product.id]?.paymentPerMonth {
                    installmentGraph[product.id]?.total_payment = paymentPerMonth * Double(planMaxPeriod)
                }
                monthlyTotal += p
                return
            }
            
            if r == 0 {
                p = round(s / paymentPeriod)
            } else {
                p = ceil(calculateF(s: s, r: r, period: paymentPeriod) / 1000) * 1000
            }
            
            installmentGraph[product.id]?.paymentPerMonth = p
            if let paymentPerMonth = installmentGraph[product.id]?.paymentPerMonth {
                installmentGraph[product.id]?.total_payment = (paymentPerMonth * paymentPeriod) + confSum
            }
            monthlyTotal += p
        }
        let totalMonthly = installmentGraph.values.reduce(0) { acc, graph in
            return acc + (graph.paymentPerMonth * graph.maxPeriod) + graph.first_fee
        }
        
        return (totalMonthly: totalMonthly, installmentGraph: installmentGraph)
    }
    
    func total(monthlyPayment: Double, initialFee: Double, paymentPeriod: Double) -> Double {
        return monthlyPayment * paymentPeriod + initialFee
    }
}
