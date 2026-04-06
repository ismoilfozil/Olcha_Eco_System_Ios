//
//  SelectDefaultCardHelper.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 13/09/23.
//

import Foundation
import Combine
public class SelectDefaultCardHelper {
    private var bag = Set<AnyCancellable>()
    private weak var bankCardsViewModel: BankCardsViewModel?
    public weak var paymentHelper: MakePaymentHelper?
    public var cardSelectedObserver: (() -> Void)?
    
    public init(bankCardsViewModel: BankCardsViewModel?,
                paymentHelper: MakePaymentHelper?
    ) {
        self.bankCardsViewModel = bankCardsViewModel
        self.paymentHelper = paymentHelper
        setupObservers()
    }
    
    private func setupObservers() {
        bankCardsViewModel?.$bankCards
            .sink { [weak self] _ in
                guard let self = self else { return }
                selectDefaultCard()
            }.store(in: &bag)
    }
    
    public func loadBankCards() {
        bankCardsViewModel?.loadBankCards()
    }
    
    public func selectDefaultCard() {
        guard bankCardsViewModel?.bankCardsData != nil else { return }
        if let defaultCard = bankCardsViewModel?.bankCardsData?.bank_cards?.first { $0.isDefault } {
            paymentHelper?.selectedCard = defaultCard
        } else if let richCard = getRichCard() {
            paymentHelper?.selectedCard = richCard
        }
        
        cardSelectedObserver?()
    }
    
    private func getRichCard() -> UserBankCardModel? {
        return bankCardsViewModel?.bankCardsData?.bank_cards?.max { ($0.bank_card?.balance ?? 0) < ($1.bank_card?.balance ?? 0) }
    }
}
