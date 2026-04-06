import Foundation
import OlchaCore
import OlchaUtils
import Alamofire
import OlchaAuth

public class EcoHeader: ApiHeader {
    
    public var items: HTTPHeaders
    
    public init(items: HTTPHeaders) {
        self.items = items
    }
    
    static var shared: EcoHeader {
        let items: HTTPHeaders = [
            "ClientModel": "ios",
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization" : AuthGlobalDefaults.getToken(),
            "organization": Organization.ecoSystem.value,
            "Accept-Language": String.getAppLanguage()
        ]
        return EcoHeader(items: items)
    }
    
}

public protocol EcoBaseApi: BaseAPI {}

extension EcoBaseApi {
    public var baseURL: String { Texts.investUrl.base }
    public var version: String { Texts.url.getVersion(1) }
    public var headers: ApiHeader { EcoHeader.shared }
    public var queryItems: [URLQueryItem] { [] }
    public var params: [String : String] { [:] }
    
    public func encode<T: Codable>(_ model: T) -> Data? {
        return try? JSONEncoder().encode(model)
    }
}
