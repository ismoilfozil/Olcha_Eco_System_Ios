import OlchaCommon
import OlchaPayModule
import OlchaNasiyaModule
import OlchaUI

public extension EcoHomeViewController {
    struct Input {
        public var builders: [BuilderSection] = []
        public var nasiyaLimit: InstallmentLimitBalanceData?
        public var payBalance: BalancesData?
        public var balance: BalanceData?
        public var bonusBalance: BonusData?
        public var banners: BannerData?
        
        public var nasiyaLimitSkeleton = Skeleton(count: 1)
        public var balanceSkeleton = Skeleton(count: 1)
        public var bannerSkeleton = Skeleton(count: 3)
        
        public init() {}
        
        public mutating func reset() {
            builders.removeAll()
            nasiyaLimit = nil
            payBalance = nil
            balance = nil
            bonusBalance = nil
            banners = nil
            balanceSkeleton.isAnimating = true
            nasiyaLimitSkeleton.isAnimating = true
        }
    }
    
    struct Output {
        public let observers = EcoHomeObservers()
        
        public init() {}
    }
}
