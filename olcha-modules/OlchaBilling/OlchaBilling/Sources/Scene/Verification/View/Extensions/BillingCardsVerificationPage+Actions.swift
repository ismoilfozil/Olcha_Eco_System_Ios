//
//  BillingCardsVerificationPage+Actions.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 17/08/23.
//

import Foundation
import OlchaVerification

public extension BillingCardsVerificationPage {
    func makeDefault(card: BillingBankCard?, parent: BillingCollectionItem) {
        bankCardViewModel.makeDefault(id: card?.getId(),
                                      filter: .init()
                                              .set(payment_alias: parent.alias)
        )
    }
    
    func delete(card: BillingBankCard?, parent: BillingCollectionItem, completion: (() -> Void)?) {
        bankCardViewModel.remove(id: card?.getId(),
                                 filter: .init()
                                         .set(payment_alias: parent.alias),
                                completion: completion
        )
    }
    
    func verifyCreditObserver() {
        verificationViewModel.loadStep()
        OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
    }
}
