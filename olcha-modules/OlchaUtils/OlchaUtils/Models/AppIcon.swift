import Foundation

public enum AppIcon: String, Codable {
    case primary = "AppIcon"
    case spring = "AppIcon-Spring"
    case summer = "AppIcon-Summer"
    case winter = "AppIcon-Winter"
    
    ///
    /// `nil` is used to reset the app icon back to its primary icon.
    ///
    public var iconName: String? {
        switch self {
        case .primary:
            return nil
        default:
            return rawValue
        }
    }
}
