import Foundation

public class EcoTab {
    private static let back_count = EcoAppConfigurator.shared.isModule ? 1 : 0
    
    public static let home = back_count + 0
    public static let market = back_count + 1
    public static let cart = back_count + 2
    public static let search = back_count + 3
    public static let profile = back_count + 4
    
    public static func back(_ index: Int?) -> Bool {
        EcoAppConfigurator.shared.isModule && (index == 0)
    }
}
