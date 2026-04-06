//
//  PriceFilterItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import OlchaUI
class PriceFilterItem: BaseTableCell {
    
    private let priceView = PriceFeatureView()
    weak var filters: ProductListFilters?
    
    override func setupViews() {
        container.addSubview(priceView)
    }
    
    override func autolayout() {
        self.priceView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        self.priceView.expandeTitle()
        self.priceView.delegate = self
    }
    
    func setup(with filters: ProductListFilters?) {
        self.filters = filters
        priceView.setFilters(filters)
    }
}

extension PriceFilterItem: PriceFeatureDelegate {
    func minPriceFilter(value: Int) {
        self.filters?.filterPrice.min = value
    }
    
    func maxPriceFilter(value: Int) {
        self.filters?.filterPrice.max = value
    }
}

