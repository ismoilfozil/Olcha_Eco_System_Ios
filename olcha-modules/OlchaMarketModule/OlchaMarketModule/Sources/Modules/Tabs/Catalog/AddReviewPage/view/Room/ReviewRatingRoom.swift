//
//  ReviewRatingRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import UIKit
import Cosmos
import OlchaUI
class ReviewRatingRoom: BaseTableCell {
    
    private let ratingTitle = UILabel()
    private let ratingView = CosmosView()
    
    weak var observers: AddReviewObserver?
    
    override func setupViews() {
        container.addSubview(ratingTitle)
        container.addSubview(ratingView)
    }
    
    override func autolayout() {
        ratingTitle.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(16)
        }
        
        ratingView.snp.makeConstraints { make in
            make.top.equalTo(ratingTitle.snp.bottom).inset(-8)
            make.left.equalToSuperview()
            make.width.equalTo(188)
            make.height.equalTo(28)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        ratingTitle.text  = "your_rating".localized()
        ratingTitle.style(.semibold, 18)
        ratingTitle.textColor = .olchaTextBlack
        ratingView.designCosmos(iconSize: 28)
        ratingView.rating = 5.0
        ratingView.didFinishTouchingCosmos = { [weak self] val in
            guard let self = self,
                  let rating = RatingType(rawValue: val.int) else { return }
            self.observers?.productRating = rating
            self.observers?.checkButtonState.send(true)
        }
    }
    
}
