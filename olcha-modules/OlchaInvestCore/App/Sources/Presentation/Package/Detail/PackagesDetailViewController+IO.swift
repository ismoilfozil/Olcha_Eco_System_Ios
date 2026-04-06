import UIKit
import OlchaUI
import OlchaUtils

public extension PackagesDetailViewController {
    struct Input {
        public var package: InvestmentModel?
        public var skeletonViews: [UIView] = []
    
        public init() {}
        
        public mutating func reset() {
            package = nil
        }
    }
    
    struct Output {
        public var investmentId: Int?
        
        public init() {}
    }
}
