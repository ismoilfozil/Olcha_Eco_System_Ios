import Foundation

public struct SearchData: Codable {
    public var products: [SearchProductItem]
    public var categories: [SearchCategoryItem]
    public var manufacturers: [SearchBrandItem]
    public var olcha_pay: [SearchPaymentItem]
    public var faqs: [SearchFaqItem]
}

public struct SearchProductItem: Codable {
    public var id: Int?
    public var name: String?
    public var alias: String?
    public var main_image: String?
    public var click_action: EcoClickAction?
}

public struct SearchCategoryItem: Codable {
    public var id: Int?
    public var name: String?
    public var alias: String?
    public var click_action: EcoClickAction?
}

public struct SearchBrandItem: Codable {
    public var id: Int?
    public var name: String?
    public var main_image: String?
    public var alias: String?
    public var click_action: EcoClickAction?
}

public struct SearchPaymentItem: Codable {
    public var name: String?
    public var logo: String?
    public var main_image: String?
    public var category_name: String?
    public var click_action: EcoClickAction?
}

public struct SearchFaqItem: Codable {
    public var id: Int?
    public var name: String?
    public var click_action: EcoClickAction?
}

public struct EcoClickAction: Codable {
    public var id: Int?
    public var action: String?
    public var alias: String?
}
