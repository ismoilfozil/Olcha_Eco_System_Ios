import Foundation

public enum VerificationStatusType: String, Codable {
    case approved
    case rejected
    case requested
    case expired
    case blocked
}
