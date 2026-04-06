//
//  FeatureModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/07/22.
//

import UIKit
import Combine
import OlchaUI
class FeatureModalPage: BaseViewController, ModalPageType {
    private let viewModel = FeaturesPageViewModel()
    private let navigationContainer = UIView()
    private let navigationTitle = UILabel()
    private let discardButton = Button()
    
    private let featuresStack = UIStackView()
    private let priceView = PriceFeatureView()
    private let featuresView = CollectionFeaturesView()
    
    
    private let separator = UIView()
    private let doneButton = Button()
    private var bag = Set<AnyCancellable>()
    
    var isPriceFilter = false
    
    weak var coordinator: FeatureCoordinatorProtocol?
    
    weak var filters: ProductListFilters?
    var mockFilters: ProductListFilters?
    
    var section: CollectionFeaturesView.Section = .brands
    
    
    override func viewDidLoad() {
        setupModalViews()
        modalAutolayout()
        configureModalViews()
        setupObservers()
    }
    
    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(navigationTitle)
        modalContainer.addSubview(discardButton)
        
        modalContainer.addSubview(featuresStack)
        featuresStack.addArrangedSubview(self.priceView)
        featuresStack.addArrangedSubview(self.featuresView)
        
        
        modalContainer.addSubview(separator)
        modalContainer.addSubview(doneButton)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        setContainerHeight(268)
        self.navigationTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
        }
        
        self.discardButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(self.navigationTitle.snp.centerY)
        }
        
        self.featuresStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.navigationTitle.snp.bottom).inset(-16)
            if self.isPriceFilter {
                make.height.equalTo(PriceFeatureView.height())
            } else {
                make.height.equalTo(CollectionFeaturesView.height())
            }
            
        }
        
        self.separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.priceView.snp.bottom).inset(-16)
            make.height.equalTo(1)
        }
        
        self.doneButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(self.separator.snp.bottom).inset(-16)
        }
        
    }
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        
        self.mockFilters = self.viewModel.cloneFilters(filters: self.filters)
        self.mockFilters?.observers = .init()
        
        if isPriceFilter {
            configurePriceView()
        } else {
            configureFeaturesView()
        }
        
        self.navigationTitle.style(.bold, 18)
        self.navigationTitle.textColor = .olchaTextBlack
        
        self.discardButton.titleLabel?.font = .style(.medium, 16)
        self.discardButton.setTitleColor(.olchaAccentColor, for: .normal)
        
        
        self.navigationTitle.text = "filters".localized()
        self.discardButton.setTitle("reset".localized(), for: .normal)
        
        
        self.separator.backgroundColor = .olchaLightNeutralDarkGray
        self.doneButton.designAccentButtons("accept".localized())
        self.priceView.delegate = self
        
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        mockFilters?
            .observers
            .filterSelected
            .sink { [weak self] isUpdated in
                guard let self = self else { return }
                if isUpdated {
                    self.loadFilteredFeatures(isManufacturer: false)
                }
            }.store(in: &bag)
        
        mockFilters?
            .observers
            .manufacturerSelected
            .sink { [weak self] isUpdated in
                guard let self = self else { return }
                if isUpdated {
                    self.loadFilteredFeatures(isManufacturer: true)
                }
            }.store(in: &bag)
        
        viewModel
            .$featuresUpdated
            .dropFirst()
            .sink { [weak self] isUpdated in
                guard let self = self else { return }
                if isUpdated {
                    if !self.isPriceFilter {
                        self.featuresView.setFilters(self.mockFilters, self.section)
                    }
                }
            }
            .store(in: &bag)
        
        doneButton.clicked { [weak self] in
            guard let self = self else { return }
            self.viewModel.convertToOriginal(filters: self.filters,
                                             mockFilters: self.mockFilters,
                                             withObservers: false)
            
            switch self.section {
            case .tags:
                self.filters?.observers.tagSelected.send(true)
                break
            case .features:
                self.filters?.observers.filterSelected.send(true)
                break
            case .brands:
                self.filters?.observers.manufacturerSelected.send(true)
                break
            }
            
            self.coordinator?.dismissViewController()
        }
        
        discardButton.clicked { [weak self] in
            guard let self = self else { return }
            if !self.isPriceFilter {
                switch self.section {
                case .tags:
                    break
                case .brands:
                    self.mockFilters?.resetSelectedManufacturers()
                    self.loadFilteredFeatures(isManufacturer: true)
                    break
                case .features(let index):
                    self.mockFilters?.resetSelectedFeatures(with: index)
                    self.loadFilteredFeatures(isManufacturer: false)
                    break
                }
                self.featuresView.setFilters(self.mockFilters, self.section)
            } else {
                self.mockFilters?.resetPrices()
                self.priceView.setFilters(self.mockFilters)
            }
        }
        
        featuresView.featuresShowButton.clicked { [weak self] in
            guard let self = self else { return }
                switch self.section {
                case .tags:
                    break
                case .brands:
                    self.showAllManufacturers()
                    break
                case .features(let index):
                    self.showAllFeatures(index: index)
                    break
                }
        }
    }
    
    func configurePriceView() {
        featuresView.isHidden = true
        priceView.isHidden = false
        priceView.setFilters(mockFilters)
    }
    
    func configureFeaturesView() {
        priceView.isHidden = true
        featuresView.isHidden = false
        dismissConfiguration()
        
        
        featuresView.setFilters(mockFilters, section)
        
    }
    
    
    func loadFilteredFeatures(isManufacturer: Bool) {
        let alias = Funcs.getCategoryAlias(category: mockFilters?.category)
        if alias != "" {
            if let mockFilters = mockFilters {
                viewModel.loadFilteredFeatures(categoryAlias: alias,
                                               filters: mockFilters,
                                               isManufacturer: isManufacturer)
            }
        }
        
    }
    
}

extension FeatureModalPage: PriceFeatureDelegate {
    func minPriceFilter(value: Int) {
        mockFilters?.filterPrice.min = value
    }
    
    func maxPriceFilter(value: Int) {
        mockFilters?.filterPrice.max = value
    }
    
    func showAllManufacturers() {
        coordinator?.pushAllManufacturersList(with: mockFilters)
    }
    
    func showAllFeatures(index: Int) {
        coordinator?.pushAllFeaturesList(with: mockFilters, index: index)
    }
}
