//
//  BillingCardsVerificationPage+IO.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 17/08/23.
//

import UIKit
import Combine
import OlchaUI

extension BillingCardsVerificationPage {
    public struct Input {
        public var parentCards : [BillingCollectionItem] = []
        public var cardsSkeleton = Skeleton(count: 3)
        public init() {}
    }
    
    public struct Output {
        public var selectedCardId: Int?
        public var selectedCardAlias: String?
        public var selectedCard: IndexPath?
        public let loadCards = PassthroughSubject<Bool, Never>()
        public init() {}
        
        public mutating func reset() {
            selectedCardAlias = nil
            selectedCardId = nil
            selectedCard = nil
        }
    }
}
