import Foundation

public struct BarcodeResponse: Codable {
    public let success: Bool
    public let code: String

    public init(success: Bool, code: String) {
        self.success = success
        self.code = code
    }
}
