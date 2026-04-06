//
//  CrudCardViewMode.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 17/03/23.
//

import Foundation
import Combine
import OlchaUI
import OlchaCore
public class CrudCardViewModel: BaseViewModel {
    
    private let addCardOTPUseCase: AddCardOTPProtocol
    
    private let verifyOTPUseCase: VerifyOTPProtocol
    
    private let removeCardUseCase: RemoveCardProtocol
    
    private let updateCardUseCase: UpdateCardProtocol
    
    @Published var addCardOTPData: LoadingState<EmptyData, BaseErrorType> = .standart
    
    @Published var verifyOTPData: LoadingState<EmptyData, BaseErrorType> = .standart
    
    @Published var removeCardData: LoadingState<EmptyData, EmptyData> = .standart
    
    @Published var updateCardData: LoadingState<UserBankCardModel, BaseErrorType> = .standart
    
    @Published var changedCardsList: LoadingState<EmptyData, BaseErrorType> = .standart
    
    public init(addCardOTPUseCase: AddCardOTPProtocol,
                verifyOTPUseCase: VerifyOTPProtocol,
                removeCardUseCase: RemoveCardProtocol,
                updateCardUseCase: UpdateCardProtocol
    ) {
        self.removeCardUseCase = removeCardUseCase
        self.addCardOTPUseCase = addCardOTPUseCase
        self.verifyOTPUseCase = verifyOTPUseCase
        self.updateCardUseCase = updateCardUseCase
    }
    
    func getOTP(card: CardModel) {
        addCardOTPData = .loading
        addCardOTPUseCase.execute(model: card)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.addCardOTPData = .success(.init())
                    break
                default:
                    self.addCardOTPData = .failure(baseResponse.validationErrors)
                    break
                }
                addCardOTPData = .standart
            }.store(in: &bag)
    }
    
    func verifyOTP(card: CardModel) {
        verifyOTPData = .loading
        verifyOTPUseCase.execute(model: card)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    verifyOTPData = .success(.init())
                    changedCardsList = .success(.init())
                default:
                    verifyOTPData = .failure(baseResponse.validationErrors)
                }
                verifyOTPData = .standart
            }.store(in: &bag)
    }
    
    func removeCard(card: UserBankCardModel?) {
        guard let id = card?.id else { return }
        removeCardData = .loading
        removeCardUseCase.execute(id: id)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    removeCardData = .success(.init())
                    changedCardsList = .success(.init())
                    changedCardsList = .standart
                default:
                    removeCardData = .failure(.init())
                }
                removeCardData = .standart
                
            }.store(in: &bag)
        
    }
    
    func updateCard(card: UserBankCardModel?) {
        guard let card = card,
              let id = card.id else { return }
        updateCardData = .loading
        updateCardUseCase.execute(id: id, model: card)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    self.updateCardData = .success(baseResponse.response)
                    break
                default:
                    self.updateCardData = .failure(.init(message: baseResponse.error))
                    break
                }
                updateCardData = .standart
            }.store(in: &bag)
    }
}
