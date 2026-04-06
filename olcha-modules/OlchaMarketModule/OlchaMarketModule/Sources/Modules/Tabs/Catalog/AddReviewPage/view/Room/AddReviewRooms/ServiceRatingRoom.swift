//
//  ReviewRatingRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/03/23.
//

import UIKit
import Cosmos
import OlchaUI
class ServiceRatingRoom: BaseTableCell {
    
    enum ServiceType: String {
        case product
        case shipping
        case call
    }

    private let stack = UIStackView()
    
    private let headerContainer = UIView()
    private let titleLabel = UILabel()
    private let ratingView = CosmosView()
    
    private let field = TMultiField()
    private let starSize: CGFloat = 22
    
    var type: ServiceType = .product {
        didSet {
            configureWithType()
        }
    }
    
    weak var observers: AddReviewObserver? {
        didSet {
            configureObserver()
        }
    }
    
    override func setupViews() {
        container.addSubview(stack)
        stack.addArrangedSubview(headerContainer)
        stack.addArrangedSubview(field)
        
        headerContainer.addSubview(titleLabel)
        headerContainer.addSubview(ratingView)
    }
    
    override func autolayout() {
        stack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        headerContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        field.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.left.right.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(ratingView.snp.left).inset(-8)
        }
        
        ratingView.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.height.equalTo(starSize)
            make.width.equalTo(188)
        }
    }
    
    override func configureViews() {
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        
        titleLabel.style(.semibold, 14)
        titleLabel.textColor = .olchaTextBlack
        
        ratingView.designCosmos(iconSize: starSize)
        ratingView.rating = 0
        ratingView.didFinishTouchingCosmos = { [weak self] val in
            guard let self = self else { return }
            switch self.type {
            case .product:
                self.observers?.productRating = .init(rawValue: val.int) ?? .none
                break
            case .shipping:
                self.observers?.shippingRating = .init(rawValue: val.int) ?? .none
                break
            case .call:
                self.observers?.callRating = .init(rawValue: val.int) ?? .none
                break
            }
            self.observers?.checkButtonState.send(true)
        }
    }
    
    private func configureWithType() {
        titleLabel.text =  "rate_\(type.rawValue)".localized()
        field.placeholder = "rate_\(type.rawValue)_placeholder".localized()
        field.isHidden = type == .product
    }
    
    private func configureObserver() {
        switch type {
        case .product:
            ratingView.rating = observers?.productRating.rawValue.double ?? 0
            break
        case .shipping:
            ratingView.rating = observers?.shippingRating.rawValue.double ?? 0
            break
        case .call:
            ratingView.rating = observers?.callRating.rawValue.double ?? 0
            break
        }
        
        
    }
}
