//
//  BrandsListRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/08/22.
//

import UIKit
import Combine
import OlchaUI
class BrandsListRoom: BaseTableCell {
    
    struct Constants {
        static let gridHeight: CGFloat = 80
        static let gridWidth: CGFloat = 144
    }
    
    private let listTitle = UILabel()
    
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())

    let seeAllButton = RightIconButton()
    
    var brands: [Manufacturer] = []
     
    weak var pushBrandObserver: PassthroughSubject<Manufacturer?, Never>?

    override func setupViews() {
        container.addSubview(listTitle)
        container.addSubview(seeAllButton)
        container.addSubview(collection)
    }
    
    override func autolayout() {
        listTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.right.equalTo(seeAllButton.snp.left).inset(-8)
        }
        
        seeAllButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: BrandItemCell.self)
        collection.backgroundColor = .olchaBackgroundColor
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        
        collection.collectionViewLayout = layout
        collection.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        collection.showsHorizontalScrollIndicator = false
        listTitle.style(.semibold, 24)
        listTitle.textColor = .olchaTextBlack
        
        
        seeAllButton.designSeeAll()
    }
    
    func setup(title: String, data: [Manufacturer]) {
        
        self.listTitle.text = title
        self.brands = data
        self.collection.reloadData()
        updateLayout()
    }
    
    private func updateLayout() {
        seeAllButton.designSeeAll()
        collection.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(listTitle.snp.bottom).inset(-16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(min(brands.count, 3).cgfloat * Constants.gridHeight)
        }
    }
}
