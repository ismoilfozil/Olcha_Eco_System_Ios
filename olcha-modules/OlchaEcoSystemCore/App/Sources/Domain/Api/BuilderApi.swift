import Foundation
import OlchaCore
import OlchaUtils

public enum BuilderApi {
    case builders
    case search(query: String)
    case balance
    case bonus
}

extension BuilderApi: EcoBaseApi {
    public var version: String {
        switch self {
        case .builders, .bonus:
            return Texts.url.getVersion(1)
        case .search:
            return Texts.url.getVersion(2)
        case .balance:
            return Texts.url.getVersion(3)
        }
    }
    
    public var baseURL: String {
        switch self {
        case .builders:
            return Texts.url.common.base
        case .search, .balance:
            return Texts.url.olcha.base
        case .bonus:
            return Texts.url.cashback.base
        }
    }
    
    public var path: String {
        switch self {
        case .builders:
            return "builder/eco"
        case .search(let query):
            return "search/eco/\(query)"
        case .balance:
            return "user/balance"
        case .bonus:
            return "member/user/bonus"
        }
    }
    
    public var method: RequestType {
        return .get
    }
    
    public var body: Data? {
        return nil
    }
    
}
