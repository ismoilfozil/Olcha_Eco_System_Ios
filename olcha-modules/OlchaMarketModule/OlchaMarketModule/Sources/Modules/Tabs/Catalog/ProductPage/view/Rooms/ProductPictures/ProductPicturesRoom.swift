//
//  ProductPicturesRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/07/22.
//

import UIKit
import Combine
import OlchaUI
class ProductPicturesRoom: BaseTableCell {
    private var bag = Set<AnyCancellable>()
    private let adultChecker = AdultChecker(withTitle: true)
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let discountLabel = UILabel()
    private let fastContainer = UIView()
    private let fastTitle = UILabel()
    private let fastIcon = IconButton()
    private let paginator = UIPageControl()
    private var pictures : [String] = []
    private var product: ProductModel?
    
    weak var pushProductMedia: PassthroughSubject<Int, Never>?
    
    var zoomObserver: ((UIImageView) -> Void)?
    
    override func setupViews() {
        container.addSubview(collection)
        container.addSubview(adultChecker)
        container.addSubview(discountLabel)
        container.addSubview(fastContainer)
        fastContainer.addSubview(fastIcon)
        fastContainer.addSubview(fastTitle)
        
        container.addSubview(paginator)
    }
    
    override func autolayout() {
        collection.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(264)
        }
        
        adultChecker.snp.makeConstraints { make in
            make.edges.equalTo(self.collection)
        }
        
        discountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(100)
        }
        
        fastContainer.snp.makeConstraints { make in
            
            make.left.equalToSuperview().inset(16)
            make.bottom.equalTo(self.collection.snp.bottom)
        }
        
        fastIcon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        fastTitle.snp.makeConstraints { make in
            make.left.equalTo(self.fastIcon.snp.right).inset(-4)
            make.top.bottom.right.equalToSuperview().inset(6)
        }
        
        paginator.snp.makeConstraints { make in
            make.height.equalTo(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.collection.snp.bottom).inset(-12)
        }
    }
    
    override func configureViews() {
        fastIcon.setIcon(.flash)
        
        discountLabel.backgroundColor = .olchaAccentColor
        discountLabel.round(6)
        discountLabel.style(.medium, 14)
        discountLabel.textColor = .olchaWhite
        discountLabel.textAlignment = .center
        
        configureCollectionView()
        
        discountLabel.text = "       "
        fastContainer.backgroundColor = .olchaWhite
        fastContainer.round(12)
        fastTitle.style(.medium, 12)
        fastTitle.textColor = .olchaPurple
        fastTitle.text = "fast_shipping".localized()
    }
    
    private func configureCollectionView() {
        paginator.tintColor = .olchaAccentColor
        paginator.currentPageIndicatorTintColor = .olchaAccentColor
        paginator.pageIndicatorTintColor = .olchaGray
        
        let pageObserver = PageObserver()
        let manager = HomeLayoutManager()
        
        self.collection.collectionViewLayout = manager.getLayout(with: .banner, observer: pageObserver)
        
        pageObserver.sink { [weak self] offset in
            guard let self = self else { return }
            self.paginator.currentPage = .page(offset: offset,
                                               collection: self.collection) ?? 0
        }.store(in: &bag)
        collection.backgroundColor = .olchaBackgroundColor
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: ProductPictureCell.self)
    }
    
    
    func setup(with data: ProductModel?) {
        product = data
        pictures = data?.images ?? []
        collection.reloadData()
        checkBadges()
        adultChecker.check(data)
    }
    
    private func checkBadges() {
        let discount = Funcs.calculateDiscount(product: self.product)
        if discount > 0 {
            discountLabel.isHidden = false
            discountLabel.text = "-" + discount.string + " %"
        } else {
            discountLabel.isHidden = true
        }
        
        let isFastDelivery: Bool = (product?.inStock ?? false)
        
        fastContainer.isHidden = !isFastDelivery
    }
}

extension ProductPicturesRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = pictures.count
        paginator.numberOfPages = count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ProductPictureCell.self, for: indexPath)
        cell.setup(with: pictures[indexPath.item])
        zoomObserver?(cell.imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushProductMedia?.send(indexPath.item)
    }
}

class ProductPicturesRoomView: BaseTableCellView {
    private var bag = Set<AnyCancellable>()
    private let adultChecker = AdultChecker(withTitle: true)
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let discountLabel = Label()
    private let fastContainer = UIView()
    private let fastTitle = UILabel()
    private let fastIcon = IconButton()
    private let paginator = UIPageControl()
    private var pictures : [String] = []
    private var product: ProductModel?
    
    weak var pushProductMedia: PassthroughSubject<Int, Never>?
    
    var zoomObserver: ((UIImageView) -> Void)?
    
    override func setupViews() {
        container.addSubview(collection)
        container.addSubview(adultChecker)
        container.addSubview(discountLabel)
        container.addSubview(fastContainer)
        fastContainer.addSubview(fastIcon)
        fastContainer.addSubview(fastTitle)
        
        container.addSubview(paginator)
    }
    
    override func autolayout() {
        collection.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(264)
        }
        
        adultChecker.snp.makeConstraints { make in
            make.edges.equalTo(self.collection)
        }
        
        discountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        fastContainer.snp.makeConstraints { make in
            
            make.left.equalToSuperview().inset(16)
            make.bottom.equalTo(self.collection.snp.bottom)
        }
        
        fastIcon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        fastTitle.snp.makeConstraints { make in
            make.left.equalTo(self.fastIcon.snp.right).inset(-4)
            make.top.bottom.right.equalToSuperview().inset(6)
        }
        
        paginator.snp.makeConstraints { make in
            make.height.equalTo(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.collection.snp.bottom).inset(-12)
        }
    }
    
    override func configureViews() {
        fastIcon.setIcon(.flash)
        
        discountLabel.backgroundColor = .olchaAccentColor
        discountLabel.round(6)
        discountLabel.settings.style(.medium, 14)
        discountLabel.settings.textColor = .olchaWhite
        discountLabel.settings.textAlignment = .center
        discountLabel.verticalInset = 2
        discountLabel.horizontalInset = 12
        
        configureCollectionView()
        
        discountLabel.text = "       "
        fastContainer.backgroundColor = .olchaWhite
        fastContainer.round(12)
        fastTitle.style(.medium, 12)
        fastTitle.textColor = .olchaPurple
        fastTitle.text = "fast_shipping".localized()
    }
    
    private func configureCollectionView() {
        paginator.tintColor = .olchaAccentColor
        paginator.currentPageIndicatorTintColor = .olchaAccentColor
        paginator.pageIndicatorTintColor = .olchaGray
        
        let pageObserver = PageObserver()
        let manager = HomeLayoutManager()
        
        self.collection.collectionViewLayout = manager.getLayout(with: .banner, observer: pageObserver)
        
        pageObserver.sink { [weak self] offset in
            guard let self = self else { return }
            self.paginator.currentPage = .page(offset: offset,
                                               collection: self.collection) ?? 0
        }.store(in: &bag)
        collection.backgroundColor = .olchaBackgroundColor
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: ProductPictureCell.self)
    }
    
    
    func setup(with data: ProductModel?) {
        product = data
        pictures = data?.images ?? []
        collection.reloadData()
        checkBadges()
        adultChecker.check(data)
    }
    
    private func checkBadges() {
        let discount = Funcs.calculateDiscount(product: self.product)
        if discount > 0 {
            discountLabel.isHidden = false
            discountLabel.text = "-" + discount.string + " %"
        } else {
            discountLabel.isHidden = true
        }
        
        let isFastDelivery: Bool = (product?.inStock ?? false)
        
        fastContainer.isHidden = !isFastDelivery
    }
}

extension ProductPicturesRoomView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = pictures.count
        paginator.numberOfPages = count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ProductPictureCell.self, for: indexPath)
        cell.setup(with: pictures[indexPath.item])
        zoomObserver?(cell.imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushProductMedia?.send(indexPath.item)
    }
}
