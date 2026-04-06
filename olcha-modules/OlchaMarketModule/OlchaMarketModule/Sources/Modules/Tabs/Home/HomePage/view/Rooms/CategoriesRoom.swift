//
//  CategoriesRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//
import OlchaUI
import UIKit
import Combine
import SkeletonView
import OlchaUtils
class CategoriesRoom: BaseTableCell {
   
    // MARK: - UI ELEMENTS
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let paginator = UIPageControl()
    
    // MARK: - Properties
    private var bag = Set<AnyCancellable>()
    private let pageObserver = PageObserver()
    private var categories: [CategoryModel] = []
    
    weak var pushCategoryObserver: PassthroughSubject<(CategoryModel?, Manufacturer?), Never>?
    
    weak var skeleton: Skeleton?
    
    override func setupViews() {
        container.addSubview(collection)
        container.addSubview(paginator)
    }
    
    override func configureViews() {
        collection.backgroundColor = .olchaBackgroundColor
        collection.registerClass(forCell: MiniCategoryItem.self)
        collection.delegate = self
        collection.dataSource = self
        
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
            collection.collectionViewLayout = layout
        }
        
        let manager = HomeLayoutManager()
        collection.collectionViewLayout = manager.getLayout(with: .categories, observer: pageObserver)
        
        pageObserver.sink { [weak self] offset in
            guard let self = self else { return }
            self.paginator.currentPage = .page(offset: offset,
                                               collection: self.collection) ?? 0
        }.store(in: &bag)
        
        paginator.currentPageIndicatorTintColor = .olchaAccentColor
        paginator.pageIndicatorTintColor = .olchaGray
        paginator.sizeToFit()
    }
    
    override func autolayout() {
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.homePageInsets)
            make.top.equalToSuperview().inset(24)
            make.height.equalTo(230)
        }
        
        paginator.snp.makeConstraints { make in
            make.top.equalTo(collection.snp.bottom)
            make.bottom.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    func setup(with data: [CategoryModel]) {
        self.categories = data
        self.collection.reloadData()
    }
    
}

extension CategoriesRoom: SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        MiniCategoryItem.classIdentifier
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = categories.count
        let perPage = 6.cgfloat
        let pageCount = (count.cgfloat / perPage).rounded(.up)
        paginator.numberOfPages = skeleton?.getPagingCount(pageCount.int) ?? pageCount.int
        
        return skeleton?.getCount(count) ?? count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MiniCategoryItem.self, for: indexPath)
        cell.configure(skeleton: skeleton)
        if categories.isGreater(indexPath) {
            cell.setup(with: categories[indexPath.item], isIcon: true)
        } else {
            cell.layoutIfNeeded()
            cell.prepareForReuse()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categories.isGreater(indexPath) {
            self.pushCategoryObserver?.send((categories[indexPath.item], nil))
        }
    }
}
