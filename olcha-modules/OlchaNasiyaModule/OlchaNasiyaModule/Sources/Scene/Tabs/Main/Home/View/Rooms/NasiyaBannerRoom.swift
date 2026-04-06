//
//  NasiyaBannerRoom.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 11/05/23.
//

import UIKit
import OlchaUI
import Combine
import OlchaCommon
class NasiyaBannerRoom: BaseTableCell {
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: NasiyaBannerItem.self)
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        
        return collection
    }()
    
    private let paginator: UIPageControl = {
        let paginator = UIPageControl()
        paginator.currentPageIndicatorTintColor = .olchaAccentColor
        paginator.pageIndicatorTintColor = .olchaLightNeutralGray
        return paginator
    }()
    
    private var banners: [BannerModel] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    weak var skeleton: Skeleton?
    
    weak var bannerClickObserver: PassthroughSubject<BannerModel?, Never>?
    
    override func setupViews() {
        container.addSubview(contentStack)
        contentStack.addArrangedSubview(collection)
        contentStack.addArrangedSubview(paginator)
    }
    
    override func autolayout() {
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collection.snp.makeConstraints { make in
            make.height.equalTo(142)
        }
        paginator.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }
    
    public func setup(banners: [BannerModel]) {
        self.banners = banners
    }

}

extension NasiyaBannerRoom: CollectionDelegates {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        paginator.numberOfPages = skeleton?.getCount(banners.count) ?? banners.count
        return skeleton?.getCount(banners.count) ?? banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(NasiyaBannerItem.self, for: indexPath)
        cell.configure(skeleton: skeleton)
        if banners.isGreater(indexPath) {
            cell.setup(url: banners[indexPath.item].image_url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let page : Int = .page(offset: scrollView.contentOffset, collection: collection) else { return }
        paginator.currentPage = page
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if banners.isGreater(indexPath) {
            bannerClickObserver?.send(banners[indexPath.item])
        }
    }
}
