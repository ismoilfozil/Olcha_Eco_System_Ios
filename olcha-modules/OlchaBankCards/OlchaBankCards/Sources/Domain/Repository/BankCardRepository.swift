//
//  BankCardRepository.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 22/06/23.
//

import Foundation
import Combine
import OlchaCore
import OlchaUtils

public protocol BankCardRepositoryProtocol {
    func verifyBankCardPhone(model: VerificationUploadCode, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BankCardData, CardUploadValidationError>, Never>
    
    func uploadBankCard(model: VerificationUploadBankCard, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
    
    func loadEntities<EntitiesOutput>(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EntitiesOutput, EmptyData>, Never>
    
    func makeDefault(id: Int, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
    
    func removeCard(id: Int, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public extension BankCardRepositoryProtocol {
    func verifyBankCardPhone(model: VerificationUploadCode, filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<BankCardData, CardUploadValidationError>, Never> {
        self.verifyBankCardPhone(model: model, filter: filter)
    }
    
    func uploadBankCard(model: VerificationUploadBankCard, filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        self.uploadBankCard(model: model, filter: filter)
    }

    func loadEntities<EntitiesOutput>(filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<EntitiesOutput, EmptyData>, Never> {
        self.loadEntities(filter: filter)
    }
    
    func makeDefault(id: Int, filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        self.makeDefault(id: id, filter: filter)
    }
    
    func removeCard(id: Int, filter: BillingPaymentFilter = .init()) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        self.removeCard(id: id, filter: filter)
    }
}


public class BankCardRepository: BaseRepository, BankCardRepositoryProtocol {
    
    private let api: BankCardAPIProtocol
    
    public init(manager: NetworkManagerProtocol,
                api: BankCardAPIProtocol) {
        self.api = api
        super.init(manager: manager)
    }
    
    public func verifyBankCardPhone(model: VerificationUploadCode, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<BankCardData, CardUploadValidationError>, Never> {
        manager.request(api: api.verifyBankCardNumber(model: model, filter: filter))
    }
    
    public func uploadBankCard(model: VerificationUploadBankCard, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        manager.request(api: api.cardUpload(model: model, filter: filter))
    }

    public func loadEntities<EntitiesOutput>(filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EntitiesOutput, EmptyData>, Never> {
        manager.request(api: api.cardDownload(filter: filter))
    }
    
    public func makeDefault(id: Int, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        manager.request(api: api.makeDefault(id: id, filter: filter))
    }
    
    public func removeCard(id: Int, filter: BillingPaymentFilter) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        manager.request(api: api.removeCard(id: id, filter: filter))
    }
}
