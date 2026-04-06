//
//  SelectableFiltersPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import OlchaUI

class SelectableFiltersPage: BaseViewController {

    let table = UITableView()
    private let viewModel = SelectableFiltersPageViewModel()
    private let acceptButton = Button()
    private let countLabelContainer = UIView()
    private let countLabel = UILabel()
    
    var section: CollectionFeaturesView.Section = .brands
    
    weak var filters: ProductListFilters? {
        didSet {
            
            switch section {
            case .tags:
                tags = (filters?.tags ?? []).filter { ($0.isEnabled ?? true) == true }
                break
            case .brands:
                manufacturers = (filters?.manufacturers ?? []).filter { ($0.isEnabled ?? true) == true }
                break
            case .features(let index):
                values = (filters?.features[index].values ?? []).filter { ($0.isEnabled ?? true) == true }
                break
            }
            
        }
    }
    
    var values: [ FeatureValue ] = []
    var manufacturers: [ Manufacturer ] = []
    var tags: [ TagModel ] = []
    
    weak var coordinator: FeatureCoordinatorProtocol?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            coordinator?.presentHistoricalDismissedViewController()
        }
    }
    
    
    override func setupViews() {
        container.addSubview(table)
        container.addSubview(acceptButton)
        container.addSubview(countLabelContainer)
        countLabelContainer.addSubview(countLabel)
    }
    
    override func autolayout() {
        countLabelContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview().inset(16)
        }
        
        table.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.countLabelContainer.snp.bottom)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
    
    override func configureViews() {
        definesPresentationContext = true
        navigation.configure(style: .clear)
        switch section {
        case .tags:
            navigation.setTitle("tags".localized())
            break
        case .brands:
            navigation.setTitle("brands".localized())
            break
        case .features(let index):
            navigation.setTitle(filters?.features[index].getName() ?? "")
            break
        }
        

        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: SelectFilterItem.self)
        table.separatorStyle = .none
        table.contentInset = .init(top: 12, left: 0, bottom: 56, right: 0)
        
        acceptButton.designAccentButtons("done".localized())
        
        countLabel.style(.bold, 16)
        countLabel.textColor = .olchaTextBlack
        countLabel.text = "selected".localized() + ": "
        countSelectedItems()
    }
    
    override func setupObservers() {
        navigation.clear.clearButton.clicked { [weak self] in
            guard let self = self else { return }
            switch self.section {
            case .tags:
                for i in 0..<self.tags.count {
                    self.tags[i].isSelected = false
                }
                break
            case .brands:
                for i in 0..<self.manufacturers.count {
                    self.manufacturers[i].isSelected = false
                }
                break
            case .features:
                for i in 0..<self.values.count {
                    self.values[i].isSelected = false
                }
                break
            }
            self.reloadTable()
        }
        
        
        acceptButton.clicked { [weak self] in
            guard let self = self else { return }
            switch self.section {
            case .tags:
                self.viewModel.convertTags(values: self.tags, filters: self.filters)
                
                self.filters?.observers.tagSelected.send(true)
                break
            case .brands:
                self.viewModel.convertManufacturers(values: self.manufacturers, filters: self.filters)
                self.filters?.manufacturers = self.manufacturers
                break
            case .features(let index):
                self.viewModel.convertFeatures(section: index, values: self.values, filters: self.filters)
                self.filters?.observers.filterSelected.send(true)
                break
            }
            
            self.coordinator?.popViewController()
        }
            
    }
    

    
    
    func countSelectedItems() {
        var count = 0
        
        switch self.section {
        case .tags:
            for i in 0..<tags.count {
                if (tags[i].isSelected ?? false) && (tags[i].isEnabled ?? true) {
                    count += 1
                }
            }
            break
        case .brands:
            for i in 0..<manufacturers.count {
                if (manufacturers[i].isSelected ?? false) && (manufacturers[i].isEnabled ?? true) {
                    count += 1
                }
            }
            break
        case .features:
            for i in 0..<self.values.count {
                if (self.values[i].isSelected ?? false) && (self.values[i].isEnabled ?? true) {
                    count += 1
                }
            }
            break
        }
        self.countLabel.text = "selected".localized() + ": " + count.string
    }
    
    func reloadTable() {
        table.reloadData()
        countSelectedItems()
    }
}
