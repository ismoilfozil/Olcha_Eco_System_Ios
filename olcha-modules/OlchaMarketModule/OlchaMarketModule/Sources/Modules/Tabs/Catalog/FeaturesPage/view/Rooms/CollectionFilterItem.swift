//
//  CollectionFilterItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import OlchaUI
class CollectionFilterItem: BaseTableCell {

    let featuresView = CollectionFeaturesView()

    override func prepareForReuse() {
        super.prepareForReuse()
        self.featuresView.filters = nil
    }
    
    override func setupViews() {
        container.addSubview(featuresView)
    }
    
    override func autolayout() {
        self.featuresView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        self.featuresView.expandeTitle()
    }
    
    func setup(with filters: ProductListFilters?,
               section: CollectionFeaturesView.Section) {
        self.featuresView.setFilters(filters, section)
    }
    
    
}
