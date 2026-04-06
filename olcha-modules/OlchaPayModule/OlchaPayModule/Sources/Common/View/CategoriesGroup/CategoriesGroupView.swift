//
//  CategoriesGroupView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 31/03/23.
//


import UIKit
import OlchaUI
public class CategoriesGroupView: BaseView {
    
    let collectionHeight: CGFloat = 140
    
    public lazy var header: GroupHeaderView = {
        let view = GroupHeaderView()
        return view
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: CategoryItem.self)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    public var items: [CategoryModel] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    var observer: ((CategoryModel?) -> Void)?
    
    let skeleton = Skeleton(count: 5)
    
    public override func setupViews() {
        addSubview(header)
        addSubview(collection)
    }
    
    public override func autolayout() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.right.equalToSuperview()
        }
        
        collection.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview()
            make.top.equalTo(header.snp.bottom).inset(-8)
            make.height.equalTo(collectionHeight)
        }
    }
    
    public func setup(data: [CategoryModel]) {
        self.items = data
        self.isHidden = data.isEmpty
    }
    
    public func resetData() {
        self.isHidden = false
        self.items = []
    }
    
    public func setupHeader(title: String) {
        header.set(title: title)
    }
    
    public func clickObserver( _ observer: @escaping (CategoryModel?) -> Void) {
        self.observer = observer
    }
    
    public override func languageUpdated() {
        collection.reloadData()
    }
    
    public func reloadData() {
        print("check reloading state", skeleton.isAnimating, isHidden)
        collection.reloadData()
    }
}
