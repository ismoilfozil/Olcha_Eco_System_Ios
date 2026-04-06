//
//  BrandsRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 01/07/22.
//

import UIKit
import Combine
import OlchaUI
//class BrandsRoom: BaseTableCell {
//    
//    private let roomTitleContainer = UIView()
//    private let roomTitle = UILabel()
//    private let seeAllButton = RightIconButton()
//    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
//    
//    var brands: [Manufacturer] = [] {
//        didSet {
//            updateLayout()
//        }
//    }
//    
//    private let cardHeight: CGFloat = 240.0
//    
//    var style: PromotedRoomView.ProductCellStyle = .white {
//        didSet {
//            container.backgroundColor = style.color
//        }
//    }
//    
//    weak var pushCategoryObserver: PassthroughSubject<(CategoryModel?, Manufacturer?), Never>?
//    
//    weak var pushAllBrandsObserver: PassthroughSubject<Bool, Never>?
//    
//    weak var pushBrandObserver: PassthroughSubject<Manufacturer?, Never>?
//    
//    override func setupViews() {
//        
//        self.container.addSubview(roomTitleContainer)
//        self.roomTitleContainer.addSubview(roomTitle)
//        self.roomTitleContainer.addSubview(seeAllButton)
//        self.container.addSubview(collection)
//    }
//    
//    override func autolayout() {
//        
//        roomTitleContainer.snp.makeConstraints { make in
//            make.left.top.right.equalToSuperview()
//        }
//        
//        roomTitle.snp.makeConstraints { make in
//            make.left.equalToSuperview().inset(Constants.homePageInsets.left * 2)
//            make.top.bottom.equalToSuperview().inset(16)
//        }
//        
//        seeAllButton.snp.makeConstraints { make in
//            make.right.equalToSuperview().inset(Constants.homePageInsets.right)
//            make.top.bottom.equalToSuperview().inset(16)
//        }
//        
//        collection.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(roomTitleContainer.snp.bottom)
//            make.bottom.equalToSuperview().inset(24)
//            make.height.equalTo(cardHeight * 2)
//        }
//        
//    }
//    
//    override func configureViews() {
//        container.backgroundColor = .olchaLightNeutralGray
//        roomTitle.roomTitleDesign()
//        seeAllButton.designSeeAll()
//        collection.backgroundColor = .clear
//        collection.delegate = self
//        collection.dataSource = self
//        collection.registerClass(forCell: BrandCardItem.self)
//        
//        updateLayout()
//        setupStaticTexts()
//        seeAllButton.settings.clicked { [weak self] in
//            guard let self = self else { return }
//            self.pushAllBrandsObserver?.send(true)
//        }
//    }
//    
//    
//    private func updateLayout() {
//        let isDoubled = (brands.count > 1)
//        collection.snp.remakeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(roomTitleContainer.snp.bottom)
//            make.bottom.equalToSuperview().inset(24)
//            make.height.equalTo(isDoubled ? (cardHeight * 2) : cardHeight)
//        }
//        
//        let manager = HomeLayoutManager()
//        let layout = manager.getLayout(with: .brands( isDoubled ? 2.0 : 1.0))
////        DispatchQueue.main.async { [weak self] in
////            guard let self = self else { return }
////            self.collection.collectionViewLayout = layout
////        }
//        UIView.animate(withDuration: 0) { [weak self] in
//            guard let self else { return }
//            collection.reloadData()
//        } completion: { [weak self] isCompleted in
//            guard let self else { return }
//            collection.collectionViewLayout = layout
//            collection.collectionViewLayout.invalidateLayout()
//        }
//    }
//    
//    func setup(with data: ManufacturersData?, withShowAll: Bool) {
//        brands = data?.manufacturers ?? []
//        seeAllButton.isHidden = !withShowAll
//        setupStaticTexts()
//        collection.reloadData()
//    }
//    
//    func configure(roomTitle: String) {
//        self.roomTitle.text = roomTitle
//    }
//    
//    private func setupStaticTexts() {
//        roomTitle.text = "brands".localized()
//        seeAllButton.designSeeAll()
//    }
//}
//
//extension BrandsRoom: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        brands.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeue(BrandCardItem.self, for: indexPath)
//        
//        cell.setup(with: brands[indexPath.row],
//                   categories: brands[indexPath.row].categories ?? [])
//        cell.pushCategoryObserver = pushCategoryObserver
//        cell.seeAllButton.clicked { [weak self] in
//            guard let self = self else { return }
//            self.pushBrandObserver?.send(self.brands[indexPath.item])
//        }
//        
//        if style == .gray {
//            cell.style = .white
//        } else {
//            cell.style = .gray
//        }
//        
//        return cell
//    }
//
//    
//    
//}
