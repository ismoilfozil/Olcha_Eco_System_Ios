//
//  PartnersViewController.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import UIKit
import OlchaUI
public class PartnersViewController: BaseViewController<SearchActionNavigationBar> {
    
    private let headerContainer: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.axis = .horizontal
        scrollView.container.alignment = .leading
        scrollView.container.spacing = 12
        scrollView.settings.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var collection: BaseCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = BaseCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        collection.registerClass(forCell: PartnerStoreItem.self)
        collection.configure()
        collection.alwaysBounceVertical = true
        return collection
    }()
    
    public lazy var regionButton: HButtonIcon = {
        let button = HButtonIcon()
        button.background = .olchaLightNeutralGray
        button.setIcon(.down_anchor?.withTintColor(.olchaTextBlack ?? .black))
        button.round(18)
        return button
    }()
    
    public lazy var categoryButton: HButtonIcon = {
        let button = HButtonIcon()
        button.background = .olchaLightNeutralGray
        button.setIcon(.down_anchor?.withTintColor(.olchaTextBlack ?? .black))
        button.round(18)
        return button
    }()
    
    var input: Input
    var output: Output
    let viewModel: PartnerViewModel
    
    weak var coordinator: PartnerCoordinatorProtocol?
    
    public init(viewModel: PartnerViewModel,
                input: Input = .init(),
                output: Output = .init()) {
        self.viewModel = viewModel
        self.input = input
        self.output = output
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(headerContainer)
        container.addSubview(collection)
        
        headerContainer.addArrangedSubview(regionButton)
        headerContainer.addArrangedSubview(categoryButton)
        
        collection.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        headerContainer.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        collection.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview()
        }
        
        headerContainer.scrollContainer.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(headerContainer.scrollContainer.snp.width)
        }
        
        let maxWidth: CGFloat = 180
        regionButton.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(maxWidth)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(maxWidth)
        }
    }
    
    public override func configureViews() {
//        languageUpdated()
    }
    
    public override func languageUpdated() {
        languageReset()
        
        navigationBar.setTitle("stores".localized(.olchaNasiyaModule))
        navigationBar.cancelButton.setTitle("cancel".localized(), for: .normal)
        navigationBar.searchField.setPlaceholder("search_stores".localized(.olchaNasiyaModule))
        setFiltersTitle()
    }
    
    public override func setupObservers() {
        
        handle(viewModel.$stores) { [weak self] data in
            guard let self = self else { return }
            output.filter.partners.models.append(
                data?.stores,
                output.filter.partners.paging
            )
            output.filter.partners.paging.finished(paginator: data?.paginator)
            collection.reloadData()
        } failure: { [weak self] error in
            guard let self = self else { return }
            output.filter.partners.paging.errorFinished()
            collection.reloadData()
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            output.filter.partners.paging.isLoading = isLoading
            output.skeleton.initialSkeleton(isAnimating: isLoading, output.filter.partners.paging)
            collection.reloadData()
        }
        
        handle(viewModel.$regions,
               success: { [weak self] data in
            guard let self = self else { return }
            output.filter.regions = data?.regions ?? []
        })
        
        handle(viewModel.$categories,
               success: { [weak self] data in
            guard let self = self else { return }
            output.filter.categories = data?.categories ?? []
        })
        
        navigationBar.cancelButton.clicked { [weak self] in
            guard let self = self else { return }
            navigationBar.searchField.textField.text = ""
            filtersUpdated()
        }
        
        navigationBar.leftButton.clicked { [weak self] in
            guard let self = self else { return }
            coordinator?.presentMenu()
        }
        
        navigationBar.searchField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
        output.filter.partnersLoader.sink { [weak self] canLoad in
            guard let self = self else { return }
            filtersUpdated()
        }.store(in: &bag)
        
        regionButton.clicked { [weak self] in
            guard let self = self else { return }
            showLoader()
            viewModel.loadRegions {
                self.hideLoader()
                self.selectRegion()
            }
        }
        
        categoryButton.clicked { [weak self] in
            guard let self = self else { return }
            showLoader()
            viewModel.loadCategories {
                self.hideLoader()
                self.selectCategory()
            }
        }
        
        navigationBar.cancelButton.clicked { [weak self] in
            guard let self = self else { return }
            navigationBar.changeStatus(.title)
            output.filter.searchText = nil
        }
    }
    
    public func setFiltersTitle() {
        if let category = output.filter.selectedCategory {
            categoryButton.setTitle(category.getTitle())
        } else {
            categoryButton.setTitle("category".localized(.olchaNasiyaModule))
        }
        
        if let region = output.filter.selectedRegion {
            regionButton.setTitle(region.getTitle())
        } else {
            regionButton.setTitle("choose_region".localized(.olchaNasiyaModule))
        }
    }
    
    public override func refreshList(_ sender: AnyObject) {
        refreshReset()
        refreshControl.endRefreshing()
    }
}

public extension PartnersViewController {
    func languageReset() {
        output.filter.resetFilters()
        
        viewModel.regions = .standart
        viewModel.categories = .standart
        
        viewModel.loadRegions()
        viewModel.loadCategories()
        resetBaseActions()
    }
 
    func refreshReset() {
        output.filter.reset()
        
        resetBaseActions()
    }
    
    func resetBaseActions() {
        collection.reloadData()
        disablePlaceholder()
        viewModel.loadPartners(filter: output.filter, cancel: true)
    }
}
