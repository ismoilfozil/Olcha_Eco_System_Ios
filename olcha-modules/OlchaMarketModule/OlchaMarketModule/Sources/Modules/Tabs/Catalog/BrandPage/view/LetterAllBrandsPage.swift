//
//  LetterAllBrandsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/08/22.
//

import UIKit
import Combine
import OlchaCore
class LetterAllBrandsPage: BaseViewController {
    
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    private var bag = Set<AnyCancellable>()
    
    private let viewModel = BrandPageViewModel()
    
    var brands: [Manufacturer] = []
    
    let paging = Paging()
    
    var letter: String = ""
    
    weak var coordinator: BrandsCoordinatorProtocol?
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(collection)
    }
    
    override func autolayout() {
        super.autolayout()
        collection.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        navigation.setTitle(letter)
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: BrandItemCell.self)
        collection.backgroundColor = .olchaBackgroundColor
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        
        collection.collectionViewLayout = layout
        collection.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        collection.showsVerticalScrollIndicator = false
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        viewModel
            .$brands
            .dropFirst()
            .sink { [weak self] value in
                guard let self = self else { return }
                
                self.paging.isLoading = false
                self.paging.total = value?.1?.paginator?.last_page ?? 1
                self.paging.current = value?.1?.paginator?.current_page ?? 1
                
                self.brands.append(contentsOf: value?.1?.manufacturers ?? [])
                self.collection.reloadData()
                
            }.store(in: &bag)
        
        viewModel
            .$brandsErrorIndex
            .dropFirst()
            .sink { [weak self] index in
                guard let self = self,
                      index != nil else {
                          return
                      }
                self.paging.isLoading = false
                self.paging.current -= 1
            }.store(in: &bag)
        
        viewModel
            .brandsCenterLoading
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.showCenterProgress() : self.hideCenterProgress()
            }.store(in: &bag)
    }
    
    override func initialRequest() {
        super.initialRequest()
        loadBrands()
    }
    
    func loadMore(index: Int) {
        if (brands.count-1) == index {
            if !paging.isLoading {
                paging.current += 1
                if paging.current <= paging.total {
                    loadBrands()
                }
            }
        }
    }
    
    private func loadBrands() {
        paging.isLoading = true
        viewModel.loadLetterBrands(letter, page: paging.current)
    }
}
