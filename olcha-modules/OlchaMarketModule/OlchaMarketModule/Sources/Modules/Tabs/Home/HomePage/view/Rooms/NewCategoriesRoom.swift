//
//  NewCategoriesRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/07/22.
//

import Combine
import UIKit
import OlchaUI
class NewCategoriesRoom: BaseTableCell {
    
    
    private let containerStack = UIStackView()
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    let footer = Button()
    
    private var categories: [CategoryModel] = []
    
    private let manager = HomeLayoutManager()
    
    weak var pushCategoryObserver: PassthroughSubject<(CategoryModel?, Manufacturer?), Never>?
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        collection.setContentOffset(.zero, animated: false)
//        
//    }
    
    override func setupViews() {
        container.addSubview(containerStack)
        containerStack.addArrangedSubview(collection)
        containerStack.addArrangedSubview(footer)
    }
    
    override func autolayout() {
        
        containerStack.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(350)
        }
        
        footer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(24)
        }
        
    }
    
    override func configureViews() {
        containerStack.axis = .vertical
        containerStack.spacing = 8
        
        containerStack.alignment = .center
        
        footer.designSeeAll()
        collection.backgroundColor = .olchaBackgroundColor
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: ImageCategoryItem.self)
        
        
        collection.collectionViewLayout = manager.getLayout(with: .newCategories)
        
    }
    
    
    func setup(with categories: CatData?, withShowAll: Bool = false) {
        self.categories = categories?.categories ?? []
        footer.designSeeAll()
        footer.isHidden = !withShowAll
        updateLayout()
    }
    
    func updateLayout() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self else { return }
            collection.reloadData()
        } completion: { [weak self] isCompleted in
            guard let self else { return }
            collection.collectionViewLayout = manager.getLayout(with: .newCategories)
            collection.collectionViewLayout.invalidateLayout()
        }
    }
}

extension NewCategoriesRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ImageCategoryItem.self, for: indexPath)
        cell.setup(with: categories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 96.0,
               height: collectionView.frame.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushCategoryObserver?.send((categories[indexPath.item], nil))
    }
}
