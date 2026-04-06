//
//  PartnerCategoriesRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 19/06/23.
//

import UIKit
import OlchaUI
public class PartnerCategoriesRoom: BaseView {
    private let manager = CollectionLayoutManager()
    private lazy var collection: DynamicCollection = {
        
        let collection = DynamicCollection(
            frame: .zero,
            collectionViewLayout: manager.getFilterItems()
        )
        
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: PartnerCategoryItem.self)
        collection.configure()
        collection.isScrollEnabled = false
        return collection
        
    }()
    
    public var categories: [CategoryModel] = [] {
        didSet {
            collectionReloader()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collection.snp.updateConstraints { make in
            make.height.equalTo(collection.contentSize.height)
        }
    }
    
    public override func setupViews() {
        addSubview(collection)
    }
    
    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    public func setup(categories: [CategoryModel]) {
        self.categories = categories
    }
    
    private func collectionReloader() {
        collection.reloadData()
        collection.layoutIfNeeded()
    }
}
