import Foundation
import OlchaUtils
public enum CommonNotificationType: String {
    case user
    case all
}
public enum CommonClickAction: ClickAction {
    case text
    
    public var module: OlchaModule? {
        nil
    }
    
    public var rawValue: String {
        switch self {
        case .text:
            return "TEXT"
        }
    }
    
    public static func fromRawValue(_ rawValue: String?, actionId: Int?, alias: String? = nil) -> CommonClickAction? {
        switch rawValue {
        case "TEXT":
            return .text
        default: return nil
        }
    }
}
