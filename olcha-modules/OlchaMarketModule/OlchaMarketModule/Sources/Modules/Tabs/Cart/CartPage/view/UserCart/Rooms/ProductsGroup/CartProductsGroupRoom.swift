//
//  CartProductsGroupRoom.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 31/01/24.
//

import UIKit
import OlchaUI
import Combine

class CartProductsGroupRoom: BaseTableCell {
    
    private let collectionHeight: CGFloat = 80
    
    private let collectionContainer: UIView = {
        let view = UIView()
        view.round(14)
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.registerClass(forCell: CartProductItem.self)
        collection.delegate = self
        collection.dataSource = self
        collection.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        return collection
    }()
    private let openButtonSize: CGFloat = 36
    lazy var openButton: IconButton = {
        let button = IconButton()
        button.setIcon(.touch_helper, edgeSize: 6, isIgnoringEdge: false)
        button.backgroundColor = .white
        button.round(openButtonSize/2)
        return button
    }()
    
    public weak var skeleton: Skeleton?
    public weak var presentProducts: PassthroughSubject<Void, Never>?
    
    private var products: [ProductModel] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    override func setupViews() {
        container.addSubview(collectionContainer)
        collectionContainer.addSubview(collection)
        container.addSubview(openButton)
    }
    
    override func autolayout() {
        collectionContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(4)
        }
        
        collection.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(collectionHeight)
            make.bottom.equalToSuperview().inset(openButtonSize/2)
        }
        
        openButton.snp.makeConstraints { make in
            make.width.height.equalTo(openButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(2)
            make.top.equalTo(collectionContainer.snp.bottom).inset(openButtonSize/2)
        }
    }
    
    override func configureViews() {
        container.backgroundColor = CartStyle.backgroundColor
    }

    public func setup(products: [ProductModel]) {
        self.products = products
    }
}

extension CartProductsGroupRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        skeleton?.getCount(products.count) ?? products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CartProductItem.self, for: indexPath)
        if products.isGreater(indexPath) {
            cell.setup(product: products[indexPath.item])
        } else {
            cell.prepareForReuse()
        }
        cell.configure(skeleton: skeleton)
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionHeight,
              height: collectionHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if products.isGreater(indexPath.item) {
            presentProducts?.send()
        }
    }
}
