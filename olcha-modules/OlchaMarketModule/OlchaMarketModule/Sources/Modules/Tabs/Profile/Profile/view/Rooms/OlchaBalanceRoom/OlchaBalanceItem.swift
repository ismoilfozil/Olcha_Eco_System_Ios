//
//  OlchaBalanceItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/02/23.
//

import UIKit
import OlchaUI
import OlchaUtils
import OlchaBalance
import OlchaAuth
class OlchaBalanceItem: BaseCollectionCell {

    public let balanceView = BalanceView()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        skeletonViews.forEach({ $0.layoutSkeletonIfNeeded() })
    }
    
    override func setupViews() {
        container.addSubview(balanceView)
    }
        
    override func autolayout() {
        balanceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        container.round()
        configureSkeleton()
    }
    
    func setup(with data: Balance?, user: User?) {
        balanceView.setup(amount: data?.getAmount(), id: data?.id)
    }
    
}

private extension OlchaBalanceItem {
    func configureSkeleton() {
        makeSkeleton(views: [
            container
        ])
    }
}
