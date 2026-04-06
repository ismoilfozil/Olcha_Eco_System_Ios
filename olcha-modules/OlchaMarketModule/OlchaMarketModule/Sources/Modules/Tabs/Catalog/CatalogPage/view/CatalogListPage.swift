//
//  CatalogListPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/07/22.
//

import UIKit
import SnapKit
import Combine
import ViewAnimator
import OlchaUI
open class CatalogListPage: BaseViewController {
    
    var bag = Set<AnyCancellable>()
    let table = UITableView()
    let acceptButton = OlchaButton()
    
    var provider = CatalogListPageProvider()
    
    public let reloadObserver = CurrentValueSubject<Bool, Never>(false)
    
    var category: CategoryModel?
    
    weak var coordinator: CatalogCoordinatorProtocol?
    
    weak var filters: ProductListFilters?
    
    var catalogStack: [CategoryModel] = []
    
    var brand: Manufacturer?
    
    public override func viewDidLoad() {
        
        setupModalViews()
        modalAutolayout()
        configureModalViews()
        setupObservers()
        
    }
    
    
    override func setupObservers() {
        reloadObserver.sink { [weak self] isReloading in
            guard let self = self else { return }
            if isReloading {
                self.provider.tableView?.reloadData()
            }
        }.store(in: &bag)
        
        
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            guard let model = self.provider.selectedCategory else { return }
            
            guard !model.isAllCategory else {
                self.coordinator?.dismiss()
                self.filters?.category = model
                return
            }
            
            self.coordinator?.dismiss()
            
            self.coordinator?.pushProductsListPage(category: model,
                                                   brand: self.brand,
                                                   catalogStack: self.provider.catalogStack)
        }
    }
    
    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(table)
        modalContainer.addSubview(acceptButton)
        
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        setContainerHeight()
        staticAutolayout()
    }
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        self.dismissConfiguration()
        
        acceptButton.setTitle("accept".localized())
        provideTableView()
    }
    
    private func staticAutolayout() {
        table.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        acceptButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    open func provideTableView() {
        self.provider.tableView = self.table
        if let category = category {
            provider.selectedCategory = category
            provider.catalogStack = catalogStack
        }
        
        self.provider.reloadObserver = self.reloadObserver
    }
}
