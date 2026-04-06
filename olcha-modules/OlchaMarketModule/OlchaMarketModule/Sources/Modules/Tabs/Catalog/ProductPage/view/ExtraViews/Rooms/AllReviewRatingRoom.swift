//
//  ReviewRatingRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/07/22.
//

import UIKit
import OlchaUI

class AllReviewRatingRoom: BaseTableCell {

    private let reviewsCountTitle = UILabel()
    private let reviewsSliderContainer = UIView()
    private let reviewsSliderValueContainer = UIView()
    private let reviewsSliderValue = UIView()
    private let percentTitle = UILabel()
    
    override func setupViews() {
        container.addSubview(reviewsCountTitle)
        container.addSubview(reviewsSliderContainer)
        reviewsSliderContainer.addSubview(reviewsSliderValueContainer)
        reviewsSliderValueContainer.addSubview(reviewsSliderValue)
        container.addSubview(percentTitle)
    }
    
    override func autolayout() {
        reviewsCountTitle.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        reviewsSliderValueContainer.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        reviewsSliderContainer.snp.makeConstraints { make in
            make.height.equalTo(6)
            make.left.equalTo(reviewsCountTitle.snp.right).inset(-12)
            make.centerY.equalToSuperview()
        }
        
        reviewsSliderValue.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0)
        }
        
        percentTitle.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalTo(reviewsSliderContainer.snp.right).inset(-12)
            make.width.equalTo(56)
        }
    }
    
    override func configureViews() {
        reviewsSliderValueContainer.backgroundColor = .clear
        reviewsCountTitle.style(.medium, 14)
        reviewsCountTitle.textColor = .olchaTextBlack
        
        percentTitle.style(.regular, 14)
        percentTitle.textColor = .olchaTextBlack
        
        reviewsSliderContainer.round(3)
        reviewsSliderContainer.backgroundColor = .lightGrayBackground1
        
        reviewsSliderValue.round(3)
        reviewsSliderValue.backgroundColor = .olchaAccentColor
    }
    
    func setup(index: Int, totalComment: TotalComments?) {
        let trueIndex = 5 - index
        let totalCount = (totalComment?.count ?? 0).double
        let count = (totalComment?.rating_count?[trueIndex] ?? 0).double
        
        reviewsCountTitle.text = (trueIndex).string + "reviews".localized()
        
        if totalCount > 0 {
            let offset = (count / totalCount * 100).round(to: 2)
            let percent = (offset)
            percentTitle.text = percent.string + " %"
            drawSlider(percent: count / totalCount)
        } else {
            percentTitle.text = (0).string + " %"
            drawSlider(percent: 0.0)
        }
        
        
    }
    
    
    private func drawSlider(percent: Double) {
        
        self.reviewsSliderValue.snp.remakeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(percent)
        }
        UIView.animate(withDuration: 1) {
            self.reviewsSliderValueContainer.layoutIfNeeded()
            
        }
    }
}
