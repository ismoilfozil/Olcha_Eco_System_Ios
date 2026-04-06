
import Foundation


public struct CloudMessagingData : Codable {
    var name_ru: String?
    var name_uz: String?
    var name_oz: String?
    var category_id: String?
    var brand_id: String?
    
    
    var product_id: String?
    var title_ru: String?
    var title_uz: String?
    var title_oz: String?

    
    var body_ru: String?
    var body_oz: String?
    var body_uz: String?
    var picture: String?
    var icon: String?
    
    
    public var click_action: String?
    
    var payment_link: String?
    var link: String?
    
    var order_id: String?
    
    var title: String?
    
    func getTitle() -> String {
        if let title = title {
            return title
        } else {
            return .lang(title_ru,
                         title_uz,
                         title_oz)
        }
    }
    
    var body: String?
    
    func getBody() -> String {
        if let body = body {
            return body
        } else {
            return .lang(body_ru,
                         body_uz,
                         body_oz)
        }
    }
    
}
