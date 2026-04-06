//
//  BrandCardItem.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/07/22.
//

import UIKit
import Combine
import OlchaUI
class BrandCardItem: BaseCollectionCell {
    

    
    private let brandContainer = UIView()
    private let brandIcon = UIImageView()
    private let brandTitle = UILabel()
    
    private let seeAllButtonContainer = UIView()
    private let seeAll = RightIconButton()
    let seeAllButton = IButton()
    
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var brand: Manufacturer?
    
    private var categories: [CategoryModel] = []
    
    
    weak var pushCategoryObserver: PassthroughSubject<(CategoryModel?, Manufacturer?), Never>?
    
    var style: PromotedRoomView.ProductCellStyle = .white {
        didSet {
            self.container.backgroundColor = style.color
            self.collection.backgroundColor = style.color
        }
    }
    
    override func setupViews() {
        
        container.addSubview(brandContainer)
        self.brandContainer.addSubview(brandIcon)
        self.brandContainer.addSubview(brandTitle)
        container.addSubview(seeAllButtonContainer)
        self.seeAllButtonContainer.addSubview(seeAll)
        self.seeAllButtonContainer.addSubview(seeAllButton)
        container.addSubview(collection)
    }
    
    override func autolayout() {
        
        self.brandContainer.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.right.lessThanOrEqualTo(self.seeAllButtonContainer.snp.left).inset(-8)
        }
        
        self.brandIcon.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.left.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        self.brandTitle.snp.makeConstraints { make in
            make.left.equalTo(brandIcon.snp.right).inset(-8)
            make.centerY.equalTo(brandIcon.snp.centerY)
            make.right.equalToSuperview().inset(12)
        }
        
        self.seeAllButtonContainer.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalTo(brandContainer.snp.bottom)

        }
        
        self.seeAll.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(8)
        }
        
        self.seeAllButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(4)
            make.top.equalTo(brandIcon.snp.bottom).inset(-24)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        self.brandContainer.backgroundColor = .olchaWhite
        self.brandContainer.round()
        self.brandIcon.contentMode = .scaleAspectFit
        self.container.backgroundColor = .olchaCardWhite
        self.container.round()
        
        self.brandTitle.style(.semibold, 14)
        self.brandTitle.textColor = .olchaTextBlack
        
        self.seeAll.designSeeAll()
        self.seeAllButtonContainer.backgroundColor = .olchaWhite
        self.seeAllButtonContainer.round()

        
        self.brandTitle.text = ""
        
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.registerClass(forCell: ImageCategoryItem.self)
        
        let manager = HomeLayoutManager()
        
        self.collection.collectionViewLayout = manager.getLayout(with: .tripleGrid)
        self.collection.isScrollEnabled = true
    }
    
    

    func setup(with data: Manufacturer?, categories: [CategoryModel]) {
        self.brand = data
        self.brandTitle.text = data?.getName()
        self.brandIcon.load(from: data?.main_image)
        self.categories = categories
        self.collection.reloadData()
        self.seeAll.designSeeAll()
    }
    
    
}
extension BrandCardItem: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if categories.count > 3 {
//            return 3
//        } else {
            return categories.count
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ImageCategoryItem.self, for: indexPath)
        if categories.isGreater(indexPath) {
            cell.setup(with: self.categories[indexPath.row], withBackgroundImage: false)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categories.isGreater(indexPath) {
            pushCategoryObserver?.send((categories[indexPath.item], brand))
        }
    }
    
}
