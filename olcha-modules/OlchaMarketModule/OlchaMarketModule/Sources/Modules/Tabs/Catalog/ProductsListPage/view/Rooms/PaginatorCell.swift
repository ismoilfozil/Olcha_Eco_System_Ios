//
//  PaginatorCell.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 10/08/22.
//

import UIKit
import OlchaUI
class PaginatorCell: BaseCollectionCell {

    let paginator = UIPageControl()
    
    override func setupViews() {
        self.container.addSubview(paginator)
    }
    
    override func autolayout() {
        paginator.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    override func configureViews() {
        paginator.tintColor = .olchaAccentColor
        paginator.currentPageIndicatorTintColor = .olchaAccentColor
        paginator.pageIndicatorTintColor = .olchaGray
    }
    
    func setup(with count: Int) {
        paginator.numberOfPages = count
    }
    
}
