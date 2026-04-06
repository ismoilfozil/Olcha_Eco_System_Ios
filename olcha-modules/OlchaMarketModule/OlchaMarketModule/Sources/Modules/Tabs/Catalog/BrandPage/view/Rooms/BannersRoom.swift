//
//  BannersRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 29/11/22.
//

import UIKit
import Combine
import OlchaUI
class BannersRoom: BaseCollectionCell {
    private var bag = Set<AnyCancellable>()
    
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let paginator = UIPageControl()
    
    private let pageObserver = PageObserver()
    
    var sliders: [Slider] = []
    
    weak var pushSliderObserver: PassthroughSubject<Slider?, Never>?
    
    override func setupViews() {
        container.addSubview(collection)
        container.addSubview(paginator)
    }
    
    override func autolayout() {
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(8)
        }
        
        paginator.snp.makeConstraints { make in
            make.height.equalTo(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.collection.snp.bottom).inset(-12)
        }
    }
    
    override func configureViews() {
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: BannerItem.self)
        collection.isPagingEnabled = true
        collection.backgroundColor = .olchaBackgroundColor
        let manager = HomeLayoutManager()
        
        collection.collectionViewLayout = manager.getLayout(with: .banner,
                                                            observer: pageObserver)
        
        
        
        paginator.pageIndicatorTintColor = .olchaAccentColor
        paginator.currentPageIndicatorTintColor = .olchaAccentColor
        paginator.pageIndicatorTintColor = .olchaGray
        
        pageObserver.sink { [weak self] offset in
            guard let self = self else { return }
            self.paginator.currentPage = .page(offset: offset,
                                               collection: self.collection) ?? 0
        }.store(in: &bag)
    }
    
    func setup(with data: [Slider]) {
        self.sliders = data
        collection.reloadData()
    }

}

extension BannersRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = sliders.count
        self.paginator.numberOfPages = count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(BannerItem.self, for: indexPath)
        cell.setup(with: sliders[indexPath.row])
        cell.configure(skeleton: .init(count: 0, isAnimating: false))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushSliderObserver?.send(sliders[indexPath.item])
    }
    
}
