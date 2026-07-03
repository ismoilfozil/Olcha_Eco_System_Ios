import Foundation

public struct ExternalProvidersResponse: Codable {
    public let providers: [ExternalInstallmentProvider]
}

public struct ExternalInstallmentProvider: Codable {
    public let id: Int
    public let alias: String
    public let name: String
    public let logoUrl: String
    public let checkoutAlias: String
    public let calculationType: String
    public let margin: Double
    public let initialFeePercent: Double
    public let minPeriod: Int
    public let maxPeriod: Int
    public let disableInitialFee: Bool
    public let infoText: String?
    public let linkText: String?
    public let linkUrl: String?
    public let badgeText: String?
    public let config: ExternalInstallmentConfig

    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case logoUrl = "logo_url"
        case checkoutAlias = "checkout_alias"
        case calculationType = "calculation_type"
        case margin
        case initialFeePercent = "initial_fee_percent"
        case minPeriod = "min_period"
        case maxPeriod = "max_period"
        case disableInitialFee = "disable_initial_fee"
        case infoText = "info_text"
        case linkText = "link_text"
        case linkUrl = "link_url"
        case badgeText = "badge_text"
        case config
    }

    public var sortedPeriods: [Int] {
        config.periodMarkups.keys.compactMap { Int($0) }.sorted()
    }

    public func monthlyPayment(totalPrice: Double, period: Int) -> Double {
        let markup = config.periodMarkups["\(period)"] ?? 0
        return totalPrice * (1.0 + markup / 100.0) / Double(max(period, 1))
    }

    public func totalPayment(totalPrice: Double, period: Int) -> Double {
        let markup = config.periodMarkups["\(period)"] ?? 0
        return totalPrice * (1.0 + markup / 100.0)
    }
}

public struct ExternalInstallmentConfig: Codable {
    public let periodMarkups: [String: Double]

    enum CodingKeys: String, CodingKey {
        case periodMarkups = "period_markups"
    }
}
