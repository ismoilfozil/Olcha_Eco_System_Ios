//
//  RatingType.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/03/23.
//

import UIKit
import Combine
enum RatingType: Int {
    case `super` = 5
    case well = 4
    case neutral = 3
    case bad = 2
    case angry = 1
    case none = -1
    
    var image: UIImage? {
        switch self {
        case .super:
            return .smile_well
        case .well:
            return .smile_well
        case .neutral:
            return .smile_neutral
        case .bad:
            return .smile_bad
        case .angry:
            return .smile_angry
        case .none:
            return nil
        }
    }
}

class AddReviewObserver {
    
    var totalRating: RatingType = .none {
        didSet {
            productRating = totalRating
            shippingRating = totalRating
            callRating = totalRating
        }
    }
    var productRating: RatingType = .none
    var shippingRating: RatingType = .none
    var callRating: RatingType = .none
    var isAnonym: Bool = false
    
    var productReview: String = ""
    var shippingReview: String = ""
    var callReview: String = ""
    
    let reloader = PassthroughSubject<Bool, Never>()
    let checkButtonState = PassthroughSubject<Bool, Never>()
    
    func getServiceRatings() -> [ReviewService] {
        var services: [ReviewService] = []
        if shippingRating != .none {
            let service = ReviewService(type: "delivery",
                                        text: shippingReview,
                                        rating: shippingRating.rawValue)
            services.append(service)
        }
        
        if callRating != .none {
            let service = ReviewService(type: "call-center",
                                        text: callReview,
                                        rating: callRating.rawValue)
            services.append(service)
        }
        return services
    }
    
    func checkCanReview() -> Bool {
        productRating != .none && productReview != ""
    }
}
