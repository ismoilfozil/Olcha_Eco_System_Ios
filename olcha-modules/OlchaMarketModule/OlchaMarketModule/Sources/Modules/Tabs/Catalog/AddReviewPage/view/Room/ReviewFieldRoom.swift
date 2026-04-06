//
//  ReviewFieldRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 02/08/22.
//

import UIKit
import OlchaUI
import Combine
class ReviewFieldRoom: BaseTableCell {
    private var bag = Set<AnyCancellable>()
    private let stackContainer = UIStackView()
    private let reviewField = TMultiField()
    private let bottomHint = UILabel()
    weak var observers: AddReviewObserver? {
        didSet {
            setupObservers()
        }
    }
    
    override func setupViews() {
        container.addSubview(stackContainer)
        stackContainer.addArrangedSubview(reviewField)
        stackContainer.addArrangedSubview(bottomHint)
    }
    
    override func autolayout() {
        stackContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        reviewField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        bottomHint.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    override func configureViews() {
        stackContainer.axis = .vertical
        stackContainer.spacing = 2
        
        bottomHint.style(.medium, 12)
        bottomHint.textColor = .olchaAccentColor
        bottomHint.text = "review_rating_required".localized()
        bottomHint.numberOfLines = 0
        reviewField.titleLabel.style(.semibold, 14)
        reviewField.placeholder = "review_placeholder".localized()
        reviewField.title = "review".localized()
        reviewField.settings.observeText { [weak self] _ in
            guard let self = self else { return }
            
            self.observers?.productReview = self.reviewField.settings.currentText
            self.observers?.checkButtonState.send(true)

        }
    }
    
    private func setupObservers() {
        if (observers?.productReview ?? "") != "" {
            reviewField.settings.setText(observers?.productReview ?? " - ")
        }
        observers?.checkButtonState.sink(receiveValue: { [weak self] canCheck in
            guard let self = self, canCheck else { return }
            checkValidation()
        }).store(in: &bag)
    }
    
    public func checkValidation() {
        bottomHint.isHidden = (self.observers?.checkCanReview() ?? false)
    }
}
