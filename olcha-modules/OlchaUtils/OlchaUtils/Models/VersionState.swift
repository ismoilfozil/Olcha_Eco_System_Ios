import Foundation

public enum VersionState: Sendable {
    case forced
    case optional
    case none
}

public struct VersionModel : Codable {
    public var status_id: Int?
    public var app_icon: AppIcon?
    
    public func getVersionState() -> VersionState {
        if let status = status_id {
            switch status {
            case 2:
                return .optional
            case 3:
                return .forced
            default:
                return .none
            }
        }
        return .none
    }
}

