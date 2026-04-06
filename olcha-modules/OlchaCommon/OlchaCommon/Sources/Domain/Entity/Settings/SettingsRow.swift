import Foundation

public enum SettingsRow {
    case language(lang: String)
    case pushNotifications(isEnabled: Bool)
    case publicOffer(url: String?)
    
    
    var title: String {
        switch self {
        case .language:
            return "settings_language".localized(.common)
        case .pushNotifications:
            return "settings_push_notifications".localized(.common)
        case .publicOffer:
            return "settings_public_offer".localized(.common)
        }
    }
}
