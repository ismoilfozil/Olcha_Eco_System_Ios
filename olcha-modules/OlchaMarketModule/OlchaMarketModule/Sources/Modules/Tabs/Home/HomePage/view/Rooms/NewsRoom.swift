//
//  NewsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/07/22.
//

import UIKit
import Combine
import OlchaUI
class NewsRoom: BaseTableCell {
    
    private let roomTitleContainer = UIView()
    private let roomTitle = UILabel()
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let seeAllButton = RightIconButton()
    
    private let cardHeight: CGFloat = 332
    
    var blogs : [Blog] = []
    
    weak var pushBlogObserver: PassthroughSubject<Blog?, Never>?
    
    override func setupViews() {
        self.container.addSubview(roomTitleContainer)
        self.roomTitleContainer.addSubview(roomTitle)
        self.roomTitleContainer.addSubview(seeAllButton)
        self.container.addSubview(collection)
    }
    
    override func autolayout() {
        
        self.roomTitleContainer.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        self.roomTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Constants.homePageInsets.left * 2)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        self.seeAllButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.homePageInsets.right)
            make.bottom.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        self.collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(roomTitleContainer.snp.bottom)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(cardHeight)
        }
        
    }
    
    override func configureViews() {
        self.container.backgroundColor = .olchaBackgroundColor
        self.roomTitle.roomTitleDesign()
        self.seeAllButton.designSeeAll()
        self.collection.backgroundColor = .clear
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.registerClass(forCell: NewsCardItem.self)
        
        self.roomTitle.text = "news".localized()
        
        let manager = HomeLayoutManager()
        self.collection.collectionViewLayout = manager.getLayout(with: .news)
    }
    
    func setup(with data: [Blog]) {
        self.blogs = data
        reloader()
    }
    
    private func reloader() {
        seeAllButton.designSeeAll()
        roomTitle.text = "news".localized()
        let manager = HomeLayoutManager()
        collection.collectionViewLayout = manager.getLayout(with: .news)
        collection.reloadData()
    }
}
extension NewsRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(NewsCardItem.self, for: indexPath)
        cell.setup(with: blogs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushBlogObserver?.send(blogs[indexPath.item])
    }
    
}
