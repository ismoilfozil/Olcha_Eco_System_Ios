//
//  ProfileCardsView+Item.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 18/07/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import OlchaUI
import OlchaBilling

public class ProfileCardsViewItem: BaseCollectionCell {
    
    let cardView = ProfileCardView()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    public override func setupViews() {
        container.addSubview(cardView)
    }
    
    public override func autolayout() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        cardView.setTitleLabel("Invest Balans")
        cardView.setIdLabel("ID: - ")
        configureSkeleton()
    }
    
    public func setup(with model: BillingCollectionItem, amountButtonClicked: (() -> Void)?) {
        guard let amount = model.balance?.amount, let currency = model.currency else { return }
        let amountText = "\(amount.string.originalPriceWithoutCurrency) \(currency.uppercased())"
        cardView.setupAmount(amountText)
        guard let id = model.balance?.id else { return }
        cardView.setIdLabel("ID: \(id)")
        if model.currency?.lowercased() == "uzs" {
            cardView.amountButtonClicked(completion: amountButtonClicked)
        }
    }
    
}

private extension ProfileCardsViewItem {
    func configureSkeleton() {
        makeSkeleton(views: [
            cardView
        ])
    }
}
