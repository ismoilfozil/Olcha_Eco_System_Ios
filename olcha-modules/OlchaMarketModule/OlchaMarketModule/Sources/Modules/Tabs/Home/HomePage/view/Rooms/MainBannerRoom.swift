//
//  MainBannerRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//
import OlchaUI
import UIKit
import SnapKit
import SkeletonView
import Combine
import OlchaUtils
class MainBannerRoom: BaseTableCell {
    // MARK: - UI ELEMENTS
    
    private let collection = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewLayout())

    private let paginator = UIPageControl()
    
    weak var pushSliderObserver: PassthroughSubject<Slider?, Never>?
        
    weak var skeleton: Skeleton?
    
    // MARK: - Properties
    private var sliders: [Slider] = []
    private let pageObserver = PageObserver()
    private var bag = Set<AnyCancellable>()

    override func setupViews() {
        container.addSubview(paginator)
        container.addSubview(collection)
    }
    
    override func configureViews() {
        backgroundColor = .olchaBackgroundColor
        collection.backgroundColor = .olchaBackgroundColor
        collection.registerClass(forCell: BannerItem.self)
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.isSkeletonable = true
        let manager = HomeLayoutManager()
        
        collection.collectionViewLayout = manager.getLayout(with: .banner,
                                                            observer: pageObserver)
        
        paginator.tintColor = .olchaAccentColor
        paginator.currentPageIndicatorTintColor = .olchaAccentColor
        paginator.pageIndicatorTintColor = .olchaGray
        
        pageObserver.sink { [weak self] offset in
            guard let self = self else { return }
            self.paginator.currentPage = .page(offset: offset,
                                               collection: self.collection) ?? 0
        }.store(in: &bag)
    }
    
    override func autolayout() {
        collection.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        
        paginator.snp.makeConstraints { make in
            make.top.equalTo(collection.snp.bottom).inset(-7)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    func setup(with data: [Slider]) {
        self.sliders = data
        self.collection.reloadData()
    }
    
}

extension MainBannerRoom: SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        BannerItem.classIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = sliders.count
        paginator.numberOfPages = skeleton?.getPagingCount(count) ?? count
        return skeleton?.getCount(count) ?? count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeue(BannerItem.self, for: indexPath)
        cell.configure(skeleton: skeleton)
        if sliders.isGreater(indexPath) {
            cell.setup(with: sliders[indexPath.item])
        } else {
            cell.layoutIfNeeded()
            cell.prepareForReuse()
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if sliders.isGreater(indexPath) {
            pushSliderObserver?.send(sliders[indexPath.item])
        }
    }
}

