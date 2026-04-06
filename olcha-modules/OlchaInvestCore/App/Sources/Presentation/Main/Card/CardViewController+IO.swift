import Foundation
import OlchaBilling
import OlchaUI

public extension CardViewController {
    struct Input {
        var parentCards: [BillingCollectionItem] = []
        var cardsSkeleton = Skeleton(count: 3)
    
        public init() {}
    }
    
    struct Output {
        var selectedCard: IndexPath?
        var selectedCardId: Int?
        var selectedCardAlias: String?
        
        var contractName: String?
        var investorId: Int?
        var contractId: Int?
        var amount: Double?
        
        var investmentId: Int?
        var paymentModelId: Int?
        var startInvest: Double?
        
        public init() {}
    }
}
