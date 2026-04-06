import Foundation

public class EcoSystemTexts {
    public static let tabNames: [String] = [
        "home_tab_item",
        "market_tab_item",
        "basket_tab_item",
        "search_tab_item",
        "profile_tab_item"
    ]
    
    static func market(_ i: Int?) -> Bool {
        (i == 1)
    }
    
    static func cart(_ i: Int?) -> Bool {
        (i == 2)
    }
}
