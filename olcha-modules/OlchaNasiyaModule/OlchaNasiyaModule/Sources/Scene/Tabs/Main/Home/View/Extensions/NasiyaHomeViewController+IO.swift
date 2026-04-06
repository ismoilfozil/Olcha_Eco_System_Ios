import Foundation
import Combine
import OlchaUI
import OlchaCommon
import OlchaAuth
import OlchaBilling
import OlchaVerification

public extension NasiyaHomeViewController {
    
    struct Input {
        public var balances: [BillingCollectionItem] = []
        public var user: User?
        public var limit: InstallmentLimitBalanceData?
        public var verification: VerificationData?
        public var banners: [BannerModel] = [] {
            didSet {
                
            }
        }
        
        public var bannersSkeleton = Skeleton(count: 2)
        public var ordersSkeleton = Skeleton(count: 3)
        
        public init() {}
    }
    
    struct Output {
        public let balanceFilled = PassthroughSubject<Void, Never>()
        public var filters = InstallmentFilter(status: .inWork)
        public let pushFillBalance = PassthroughSubject<BillingCollectionItem, Never>()
        public let bannerClickObserver = PassthroughSubject<BannerModel?, Never>()
        
        public init() {}
    }
    
}
