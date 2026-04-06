
import Foundation
import OlchaCore
import OlchaUtils

import OlchaBankCards

public class BillingBankCardAPI: BankCardAPIProtocol {
    
    public func verifyBankCardNumber(model: VerificationUploadCode, filter: BillingPaymentFilter) -> BaseAPI {
        model.payment_system_alias = filter.getPaymentAlias()
        let api = BaseBillingApi(path: "api-payments/send-otp",
                                 version: Texts.url.getVersion(1),
                                 method: .post,
                                 body: model,
                                 headers: BaseBillingBankCardsHeader.headers()
        )
        return api
    }
    
    public func cardUpload(model: VerificationUploadBankCard, filter: BillingPaymentFilter) -> BaseAPI {
        model.payment_system_alias = filter.getPaymentAlias()
        let api = BaseBillingApi(path: "api-payments/confirm-otp",
                                 version: Texts.url.getVersion(1),
                                 method: .post,
                                 body: model,
                                 headers: BaseBillingBankCardsHeader.headers())
        return api
    }
    
    public func cardDownload(filter: BillingPaymentFilter) -> BaseAPI {
        var queryItems: [URLQueryItem] = []
        if filter.getPaymentAlias() != "" {
            queryItems = [
                .init(name: "payment_system_alias",
                      value: filter.getPaymentAlias())
            ]
        }
        let api = BaseBillingApi(path: "api-payments/external-entities",
                                 version: Texts.url.getVersion(1),
                                 method: .get,
                                 queryItems: queryItems,
                                 headers: BaseBillingBankCardsHeader.headers()
        )
        return api
    }
    
    public func removeCard(id: Int, filter: BillingPaymentFilter) -> BaseAPI {
        let model = EntityID(external_entity_id: id,
                             payment_system_alias: filter.getPaymentAlias())
        let api = BaseBillingApi(path: "api-payments/external-entities",
                                 version: Texts.url.getVersion(1),
                                 method: .delete,
                                 body: model,
                                 headers: BaseBillingBankCardsHeader.headers()
        )
        
        return api
    }
    
    public func makeDefault(id: Int, filter: BillingPaymentFilter) -> BaseAPI {
        let model = EntityID(external_entity_id: id,
                             payment_system_alias: filter.getPaymentAlias())
        let api = BaseBillingApi(path: "api-payments/external-entities/set-default",
                                 version: Texts.url.getVersion(1),
                                 method: .post,
                                 body: model,
                                 headers: BaseBillingBankCardsHeader.headers()
        )
        
        return api
    }
}
