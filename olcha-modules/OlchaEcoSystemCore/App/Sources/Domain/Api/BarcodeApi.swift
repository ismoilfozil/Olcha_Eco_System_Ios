import Foundation
import OlchaCore
import OlchaUtils

public enum BarcodeApi {
    case generateBarcode(userId: Int)
}

extension BarcodeApi: EcoBaseApi {
    public var version: String {
        return ""
    }

    public var baseURL: String {
        return "https://merchant.olchanasiya.uz"
    }

    public var path: String {
        switch self {
        case .generateBarcode:
            return "api/barcode/generate"
        }
    }

    public var method: RequestType {
        return .post
    }

    public var body: Data? {
        switch self {
        case .generateBarcode(let userId):
            let parameters: [String: Any] = ["user_id": userId]
            return try? JSONSerialization.data(withJSONObject: parameters)
        }
    }
}
