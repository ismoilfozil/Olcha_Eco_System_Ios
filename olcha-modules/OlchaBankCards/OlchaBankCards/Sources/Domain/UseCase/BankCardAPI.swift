
import Foundation
import OlchaCore
import OlchaUtils

public protocol BankCardAPIProtocol {
    func verifyBankCardNumber(model: VerificationUploadCode, filter: BillingPaymentFilter) -> BaseAPI
    func cardUpload(model: VerificationUploadBankCard, filter: BillingPaymentFilter) -> BaseAPI
    func cardDownload(filter: BillingPaymentFilter) -> BaseAPI
    func removeCard(id: Int, filter: BillingPaymentFilter) -> BaseAPI
    func makeDefault(id: Int, filter: BillingPaymentFilter) -> BaseAPI
}

public extension BankCardAPIProtocol {
    func verifyBankCardNumber(model: VerificationUploadCode, filter: BillingPaymentFilter = .init()) -> BaseAPI {
        self.verifyBankCardNumber(model: model, filter: filter)
    }
    
    func cardUpload(model: VerificationUploadBankCard, filter: BillingPaymentFilter = .init()) -> BaseAPI {
        self.cardUpload(model: model, filter: filter)
    }
    
    func cardDownload(filter: BillingPaymentFilter = .init()) -> BaseAPI {
        self.cardDownload(filter: filter)
    }
    
    func removeCard(id: Int, filter: BillingPaymentFilter = .init()) -> BaseAPI {
        self.removeCard(id: id, filter: filter)
    }
    
    func makeDefault(id: Int, filter: BillingPaymentFilter = .init()) -> BaseAPI {
        self.makeDefault(id: id, filter: filter)
    }
}

open class BankCardAPI: BankCardAPIProtocol {
    
    public init() {}
    
    public func verifyBankCardNumber(model: VerificationUploadCode, filter: BillingPaymentFilter) -> OlchaCore.BaseAPI {
        let api = BaseBankCardAPI(path: "installment/verify-number", method: .post)
        api.body = api.encode(model)
        return api
    }
    
    public func cardUpload(model: VerificationUploadBankCard, filter: BillingPaymentFilter) -> OlchaCore.BaseAPI {
        let api = BaseBankCardAPI(path: "installment/verify-number-check", method: .post)
        api.body = api.encode(model)
        return api
    }
    
    public func cardDownload(filter: BillingPaymentFilter) -> OlchaCore.BaseAPI {
        let api = BaseBankCardAPI(path: "user/mycards", method: .get)
        return api
    }
    
    public func removeCard(id: Int, filter: BillingPaymentFilter) -> OlchaCore.BaseAPI {
        let api = BaseBankCardAPI(path: "user/mycards/delete",
                                  method: .get,
                                  queryItems: [
                                    .init(name: "id", value: "\(id)")
                                  ])
        return api
    }
    
    public func makeDefault(id: Int, filter: BillingPaymentFilter) -> OlchaCore.BaseAPI {
        let api = BaseBankCardAPI(path: "user/mycards/default",
                                  method: .post)
        api.body = api.encode(RequestId(id: id))
        return api
    }
}


