//
//  BankCardViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/11/22.
//

import Foundation
import Combine
import OlchaUI
import OlchaAuth
import OlchaCore
import OlchaUtils
#warning("Auth credit")

open class BankCardViewModel: BaseViewModel {
    
    @Published public var codeSent: Bool = false
    @Published public var cardUploaded: LoadingState<EmptyData, BaseErrorType> = .standart
    @Published public var bankCard: LoadingState<BankCard, CardUploadError> = .standart
    @Published public var cards: LoadingState<[BankCard], BaseErrorType> = .standart
    @Published public var removeCard: LoadingState<EmptyData, BaseErrorType> = .standart
    
    public var creditVerificationObserver: (() -> Void)?
    
    private let verifyBankCardPhoneUseCase: VerifyBankCardPhoneProtocol
    private let uploadBankCardUseCase: UploadBankCardProtocol
    private let loadBankCardsUseCase: LoadBankCardsProtocol
    private let makeDefaultUseCase: MakeDefaultProtocol
    private let removeCardUseCase: RemoveCardProtocol
    
    public init(verifyBankCardPhoneUseCase: VerifyBankCardPhoneProtocol,
                uploadBankCardUseCase: UploadBankCardProtocol,
                loadBankCardsUseCase: LoadBankCardsProtocol,
                makeDefaultUseCase: MakeDefaultProtocol,
                removeCardUseCase: RemoveCardProtocol) {
        self.verifyBankCardPhoneUseCase = verifyBankCardPhoneUseCase
        self.uploadBankCardUseCase = uploadBankCardUseCase
        self.loadBankCardsUseCase = loadBankCardsUseCase
        self.makeDefaultUseCase = makeDefaultUseCase
        self.removeCardUseCase = removeCardUseCase
    }
    
    public func verifyBankCardPhone(model: VerificationUploadCode,
                                    filter: BillingPaymentFilter = .init()) {
        let updatedExpiry = getCorrect(expiry: model.expiry)
        let filteredModel = VerificationUploadCode(pan: model.pan.phoneNumber,
                                                   expiry: updatedExpiry,
                                                   phone: model.phone.phoneNumber)
        verifyBankCardPhoneUseCase.execute(model: filteredModel, filter: filter)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    let data = baseResponse.response
                    if let card = data?.data {
                        self.bankCard = .success(card)
                        self.creditVerificationObserver?()
                    } else {
                        self.codeSent = true
                    }
                    break
                default:
                    self.bankCard = .failure(
                        .init(code: baseResponse.errors?.code,
                              message: baseResponse.error,
                              errors: baseResponse.errors?.validations)
                    )
                    break
                }
            }.store(in: &bag)
        
    }
    
    public func uploadBankCard(model: VerificationUploadBankCard,
                               filter: BillingPaymentFilter = .init()) {
        
        let filteredModel = VerificationUploadBankCard(pan: model.pan.phoneNumber,
                                                       expiry: getCorrect(expiry: model.expiry),
                                                       phone: model.phone.phoneNumber,
                                                       code: model.code)
        
        uploadBankCardUseCase.execute(model: filteredModel, filter: filter)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.cardUploaded = .success(.init())
                    self.creditVerificationObserver?()
                    break
                default:
                    self.cardUploaded = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
        
    }
    
    public func loadBankCards(filter: BillingPaymentFilter = .init()) {
        guard AuthGlobalDefaults.isUser() else { self.cards = .success([]); return }
        self.cards = .loading
        
        loadBankCardsUseCase.execute(filter: filter)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.cards = .success(baseResponse.response?.bank_cards ?? [])
                    break
                default:
                    self.cards = .failure(.init(message: baseResponse.error))
                    break
                }
            }.store(in: &bag)
     
    }
    
    public func makeDefault(id: Int?, filter: BillingPaymentFilter = .init()) {
        guard let id = id else { return }
        
        makeDefaultUseCase.execute(id: id, filter: filter).sink { _ in
            
        }.store(in: &bag)
        
    }
    
    public func remove(id: Int?, filter: BillingPaymentFilter = .init(), completion: (() -> Void)?) {
        guard let id = id else { return }
        removeCard = .loading
        removeCardUseCase.execute(id: id,
                                  filter: filter)
        .sink { [weak self] baseResponse in
            guard let self = self else { return }
            
            switch baseResponse.status {
            case .success:
                completion?()
                removeCard = .success(baseResponse.response)
                creditVerificationObserver?()
            default:
                removeCard = .failure(baseResponse.baseError)
            }
        }.store(in: &bag)
        
    }
    
    private func getCorrect(expiry: String) -> String {
        guard expiry.phoneNumber.count == 4 else {
            return ""
        }
        
        return expiry.phoneNumber[2..<4] + expiry.phoneNumber[0..<2]
    }
}
