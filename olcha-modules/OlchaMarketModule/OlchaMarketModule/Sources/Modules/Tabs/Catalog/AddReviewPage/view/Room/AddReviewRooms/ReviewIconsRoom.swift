//
//  ReviewIconsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/03/23.
//

import UIKit
import OlchaUI
class ReviewIconsRoom: BaseTableCell {

    private let titleLabel = UILabel()
    private let buttonsStack = UIStackView()
    
    private var buttons: [IconButton] = []
    
    private let types: [RatingType] = [
        .angry,
        .bad,
        .neutral,
        .well,
        .super
    ]
    
    private let sizeButton: CGFloat = 45
    
    var ratingType: RatingType = .none {
        didSet {
            ratingClicked()
        }
    }
    
    weak var observers: AddReviewObserver? {
        didSet {
            configureObserver()
        }
    }
    
    var ratingClickedObserver: (() -> Void)?
    
    override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(buttonsStack)
    }
    
    override func autolayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(sizeButton)
        }
    }
    
    override func configureViews() {
        titleLabel.style(.medium, 14)
        titleLabel.text = "review_title".localized()
        titleLabel.textColor = .olchaTextBlack
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 16
        buttonsStack.alignment = .center
        
        createButtons()
    }
    
    private func createButtons() {
        buttons.removeAll()
        buttonsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 0..<types.count {
            let button = IconButton()
            button.snp.makeConstraints { $0.width.height.equalTo(sizeButton) }
            button.setIcon(types[i].image?.withColor(.lightGray), isIgnoringEdge: true)
            buttons.append(button)
            buttonsStack.addArrangedSubview(button)
            
            button.clicked { [weak self] in
                guard let self = self else { return }
                self.ratingType = self.types[i]
                self.ratingClickedObserver?()
            }
        }
    }
    
    private func ratingClicked() {
        observers?.totalRating = ratingType
        
        for i in 0..<min(buttons.count, types.count) {
            buttons[i].setIcon(types[i].image?.withColor(.lightGray), isIgnoringEdge: true)
            if types[i] == ratingType {
                buttons[i].setIcon(types[i].image, isIgnoringEdge: true)
            }
        }
    }
    
    private func configureObserver() {
        if let ratingType = observers?.totalRating {
            self.ratingType = ratingType
        }
    }
}
