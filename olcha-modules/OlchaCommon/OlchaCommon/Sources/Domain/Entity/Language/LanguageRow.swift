import Foundation

public enum LanguageRow: String {
    case ru
    case oz
    
    var title: String {
        switch self {
        case .ru: return "russian_language".localized(.common)
        case .oz: return "uzbek_language".localized(.common)
        }
    }
    
    var key: String {
        switch self {
        case .ru: return "ru"
        case .oz: return "oz"
        }
    }
}
