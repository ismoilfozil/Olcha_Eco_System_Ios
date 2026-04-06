/// ``WebviewAction``
/// `WEBVIEW`
/// created by Akhrorhuja
import Foundation
public enum WebviewClickAction: ClickAction {
    
    case webview(deeplink: String?)
    
    public var module: OlchaModule? {
        nil
    }
    
    public var rawValue: String {
        switch self {
        case .webview:
            return "WEBVIEW"
        }
    }
    
    public static func fromRawValue(_ rawValue: String?, actionId: Int?, alias: String?) -> WebviewClickAction? {
        switch rawValue {
        case "WEBVIEW":
            return .webview(deeplink: alias)
        default:
            return nil
        }
    }
    
}
