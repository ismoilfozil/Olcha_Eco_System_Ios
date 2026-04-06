//
//  HomeNewsView.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 15/03/23.
//

import UIKit
import OlchaUI

public class HomeNewsView: BaseView {
    
    public lazy var header: GroupHeaderView = {
        let view = GroupHeaderView()
        return view
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: HomeNewsItem.self)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    var newsClickedObserver: ((Int) -> Void)?
    
    var news: [NewsModel] = [] {
        didSet {
            collection.reloadData()
            header.seeAllHidden = news.count < 4
        }
    }
    
    let skeleton = Skeleton(count: 12)
    
    public override func setupViews() {
        addSubview(header)
        addSubview(collection)
    }
    
    public override func autolayout() {
        header.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(collection.snp.top).inset(-8)
        }
        
        collection.snp.makeConstraints { make in
            make.height.equalTo(190)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    public func setup(data: [NewsModel]) {
        self.news = data
        self.isHidden = data.isEmpty
    }
    
    public func resetData() {
        self.isHidden = false
        self.news = []
    }
    
    public func setupHeader(title: String = "news".localized()) {
        header.set(title: title)
    }
    
    public func newsClicked(_ observer: ((Int) -> Void)?) {
        self.newsClickedObserver = observer
    }
    
    public override func languageUpdated() {
        collection.reloadData()
    }
    
    public func reloadData() {
        collection.reloadData()
    }
}
