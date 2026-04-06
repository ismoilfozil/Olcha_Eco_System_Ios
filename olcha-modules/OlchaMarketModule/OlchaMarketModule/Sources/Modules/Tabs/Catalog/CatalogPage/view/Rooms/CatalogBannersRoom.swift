//
//  CatalogBannersRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/08/22.
//

import UIKit
import Combine
import OlchaUI
class CatalogBannersRoom: BaseCollectionCell {
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let pageObserver = PageObserver()
    private var bag = Set<AnyCancellable>()
    let paginator = UIPageControl()
    
    var slidersData: SlidersData? {
        didSet {
            if let hex = slidersData?.pagination_color {
                paginator.tintColor = .hex(hex)
                paginator.currentPageIndicatorTintColor = .hex(hex)
            } else {
                paginator.tintColor = .olchaAccentColor
                paginator.currentPageIndicatorTintColor = .olchaAccentColor
            }
        }
    }
    var banners: [Slider] = []
    
    weak var pushSliderObserver: PassthroughSubject<Slider?, Never>?
    
    override func setupViews() {
        container.addSubview(collection)
        container.addSubview(paginator)
    }
    
    override func autolayout() {
        
        collection.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
        
        paginator.snp.makeConstraints { make in
            make.top.equalTo(collection.snp.bottom).inset(-7)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    override func configureViews() {
        container.backgroundColor = .clear
        collection.backgroundColor = .olchaBackgroundColor
        collection.registerClass(forCell: BannerItem.self)
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        let manager = HomeLayoutManager()
        
        collection.collectionViewLayout = manager.getLayout(with: .banner,
                                                            observer: pageObserver)
        
        
        
        paginator.pageIndicatorTintColor = .olchaGray
        
        pageObserver.sink { [weak self] offset in
            guard let self = self else { return }
            self.paginator.currentPage = .page(offset: offset,
                                               collection: self.collection) ?? 0
        }.store(in: &bag)
    }
    
    func setup(with data: SlidersData?) {
        self.slidersData = data
        self.banners = data?.banners ?? []
        collection.reloadData()
    }
    
}
