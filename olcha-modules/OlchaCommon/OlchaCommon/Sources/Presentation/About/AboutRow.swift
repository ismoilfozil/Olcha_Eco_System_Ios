import UIKit
import OlchaUI

public enum AboutRow: RowProtocol {
    case rate
    case share
    
    public var title: String {
        switch self {
        case .rate: return "about_rate_us".localized(.common)
        case .share: return "about_share".localized(.common)
        }
    }
    
    public var image: UIImage? {
        switch self {
        case .rate: return .star
        case .share: return .shareAlt
        }
    }
}
