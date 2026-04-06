import Foundation

public struct BuilderData: Codable {
    public var builder: [BuilderSection]
}

public enum BuilderModule: String, Codable {
    case market
    case invest
    case nasiya
    case pay
    case sayohat
}

public enum BuilderLayoutType: String, Codable {
    case horizontalCategories = "horizontal_categories"
    case verticalBanners = "vertical_banners"
    case gridBanners = "grid_banners"
    case gridCategories = "grid_categories"
}

public struct BuilderSection: Codable {
    public var module: BuilderModule
    public var section_name: String?
    public var layout_type: BuilderLayoutType
    public var items: [BuilderSectionItem]
    
    public var cellType: BuilderCollectionCell.Type {
        switch layout_type {
        case .horizontalCategories:
            return HorizontalCategoryCollectionCell.self
        case .verticalBanners:
            return VerticalBannerCollectionCell.self
        case .gridBanners:
            return GridBannerCollectionCell.self
        case .gridCategories:
            return GridCategoryCollectionCell.self
        }
    }
}

public struct BuilderSectionItem: Codable {
    public var image_url: String?
    public var title: String?
    public var click_action: String?
    public var click_action_id: String?
    public var background_color: String?
    public var deeplink: String?
}
