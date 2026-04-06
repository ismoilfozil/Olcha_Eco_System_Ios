//
//  CatalogSubcatsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/08/22.
//

import UIKit
import Combine
import OlchaUI
class CatalogSubcatsRoom: BaseCollectionCell {

    let categoriesCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var categories: [CategoryModel] = []
    
    weak var pushSubcatalogObserver: PassthroughSubject<CategoryModel?, Never>?
     
    let gridCount: CGFloat = 3
    
    let heightOffset: CGFloat = 1.3
    
    override func setupViews() {
        container.addSubview(categoriesCollection)
    }
    
    override func autolayout() {
        categoriesCollection.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.left.equalToSuperview().inset(8)
        }
    }
    
    override func configureViews() {
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        categoriesCollection.registerClass(forCell: BackgroundedImage.self)
        categoriesCollection.backgroundColor = .olchaBackgroundColor
        let otherManager = OtherLayoutManager()
        categoriesCollection.collectionViewLayout = otherManager.getLayout(
            with: .vGridCount(count: gridCount.int,
                              heightOffset: heightOffset)
        )
        
    }
    
    
    func setup(with data: [CategoryModel]) {
        
        categories = data
        categoriesCollection.reloadData()
        updateLayout()
    }
    
    private func updateLayout() {
        
        let rowsCount = (categories.count.cgfloat / gridCount).rounded(.up)
        
        categoriesCollection.snp.remakeConstraints { make in
            make.right.left.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(categoriesCollection.snp.width).multipliedBy((1/gridCount) * heightOffset * rowsCount)
        }
    }
}
