//
//  PopularRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/07/22.
//

import UIKit
import Combine
import OlchaUI
class PopularRoom: BaseCollectionCell {
    
    private let provider = ProductsCollectionProvider()
    
    
    private let titleRoom = UILabel()
    private let subtitleRoom = UILabel()
    private let productsCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private var products: [ProductModel] = []
    
    weak var productHelper: ProductHelper? {
        didSet {
            provider.productHelper = productHelper
        }
    }
    
    override func setupViews() {
        
        self.container.addSubview(titleRoom)
        self.container.addSubview(subtitleRoom)
        self.container.addSubview(productsCollection)
    }
    
    override func autolayout() {
        
        self.titleRoom.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        self.subtitleRoom.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.titleRoom.snp.bottom).inset(-4)
        }
        
        self.productsCollection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.subtitleRoom.snp.bottom).inset(-16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        self.titleRoom.style(.semibold, 20)
        self.titleRoom.textColor = .olchaTextBlack
        
        self.subtitleRoom.style(.medium, 14)
        self.subtitleRoom.textColor = .olchaLightTextColornnnnnn
        
        self.titleRoom.text = "Популярные предложения"
        self.subtitleRoom.text = "Спонсорские товары"
        
        self.provider.collection = self.productsCollection
        self.container.backgroundColor = .olchaLightNeutralGray
        self.productsCollection.backgroundColor = .clear
    }
    
    func setup(with data: [ProductModel]) {
        self.products = data
        self.provider.configure(with: self.products,
                                cellType: .shrink,
                                isVertical: false,
                                space: 0)
        
    }
    
}
