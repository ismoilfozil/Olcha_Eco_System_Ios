//
//  FeaturesPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import Combine
import OlchaUI
class FeaturesPage: BaseViewController {
    enum Section {
        case price
        case tags
        case brands
        case features
    }
    
    let table = BaseTableView()
    
    private let viewModel = FeaturesPageViewModel()
    
    private let acceptButton = UIButton()
    
    weak var filters: ProductListFilters?
    
    weak var coordinator: FeatureCoordinatorProtocol?
    
    var mockFilters: ProductListFilters?
    private var bag = Set<AnyCancellable>()
    
    let sections: [Section] = [
        .price,
        .tags,
        .brands,
        .features
    ]
    
    override func setupViews() {
        self.container.addSubview(table)
        self.container.addSubview(acceptButton)
    }
    
    override func autolayout() {
        self.table.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.acceptButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
    
    override func configureViews() {
        self.mockFilters = self.filters?.copy()
        self.navigation.configure(style: .clear)
        
        self.navigation.clear.clearButton.addTarget(self, action: #selector(rightButtonClicked), for: .touchUpInside)
        
        self.navigation.setTitle("filters".localized())
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.registerClass(forCell: PriceFilterItem.self)
        self.table.registerClass(forCell: CollectionFilterItem.self)
        self.table.separatorStyle = .none
        self.table.contentInset = .init(top: 12, left: 0, bottom: 60, right: 0)
        
        
        
        self.acceptButton.designAccentButtons("accept".localized())
        self.acceptButton.addTarget(self, action: #selector(acceptChanges), for: .touchUpInside)
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        viewModel.$featuresUpdated.sink { [weak self] isUpdated in
            guard let self = self else { return }
            if isUpdated {
                self.table.reloadData()
            }
        }.store(in: &bag)
        
        mockFilters?
            .observers
            .filterSelected
            .sink{ [weak self] isUpdated in
                guard let self = self else { return }
                if isUpdated {
                    self.mockFilters?.featureSelected(type: .features)
                    self.table.reloadData()
                    self.loadFilteredFeatures(isManufacturer: false)
                }
            }.store(in: &bag)
        
        mockFilters?
            .observers
            .manufacturerSelected
            .sink{ [weak self] isUpdated in
                guard let self = self else { return }
                if isUpdated {
                    self.mockFilters?.featureSelected(type: .features)
                    self.table.reloadData()
                    self.loadFilteredFeatures(isManufacturer: true)
                }
            }.store(in: &bag)
        
        mockFilters?
            .observers
            .tagSelected
            .sink { [weak self] isUpdated in
                guard let self = self else { return }
                if isUpdated {
                    self.mockFilters?.featureSelected(type: .tag)
                    self.table.reloadData()
                }
            }.store(in: &bag)
        
    }
    
    func loadFilteredFeatures(isManufacturer: Bool) {
        let alias = Funcs.getCategoryAlias(category: mockFilters?.category)
        
        if alias != "" {
            if let mockFilters = mockFilters {
                viewModel.loadFilteredFeatures(categoryAlias: alias, filters: mockFilters, isManufacturer: isManufacturer)
            }
        }
    }
    
    
}

extension FeaturesPage {
    @objc func rightButtonClicked() {
        self.mockFilters?.resetAllSelectedFeatures()
        self.table.reloadData()
    }
    
    @objc func acceptChanges() {
        self.viewModel.convertToOriginal(filters: self.filters,
                                         mockFilters: self.mockFilters)
        
        self.filters?.observers.loadProductsObserver.send(true)
        
        self.coordinator?.popViewController()
    }
}
