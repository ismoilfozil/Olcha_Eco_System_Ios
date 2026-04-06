//
//  SearchPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/10/22.
//

import UIKit
import Combine
import OlchaUI
class SearchPage: BaseViewController, UITextFieldDelegate {
    
    private let table = BaseTableView()
    
    enum Section: Int {
        case history = 0
        case category = 1
        case brand = 2
        case products = 3
    }
    
    let sections: [Section] = [
        .history,
        .category,
        .brand,
        .products
    ]
    
    private var bag = Set<AnyCancellable>()
    
    let viewModel = SearchPageViewModel()
    
    var products: [ProductModel] = []
    var brands: [Manufacturer] = []
    var categories: [CategoryModel] = []
    
    var isEmpty: Bool {
        return (products.isEmpty && brands.isEmpty && categories.isEmpty) && ((textField().text?.isEmpty ?? true) == false)
    }
    
    weak var coordinator: SearchCoordinatorProtocol?
    
    var forcedSearchQuery: String?
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        navigation.configure(style: .search)
        
        textField().addTarget(self,
                              action: #selector(textFieldEditing(_:)),
                              for: .editingChanged)
        
        textField().addTarget(self,
                              action: #selector(textFieldEdited(_:)),
                              for: .editingDidEnd)
        
        textField().delegate = self
        textField().returnKeyType = .search
        
        
        table.registerClass(forCell: SearchTextRoom.self)
        table.registerClass(forCell: SearchImageRoom.self)
        table.delegate = self
        table.dataSource = self
        table.configure()
        
        placeholder.titleLabel.style(.semibold, 22)
        placeholder.subtitleLabel.style(.medium, 16)
        placeholder.subtitleLabel.textColor = .olchaLightTextColornnnnnn
        placeholder.removeContent()
        
        languageUpdated()
    }
    
    override func languageUpdated() {
        placeholder.setupTitle("empty_search_title".localized())
        placeholder.setupSubtitle("empty_search_subtitle".localized())
    }
    
    @objc func textFieldEditing(_ sender: UITextField) {
        viewModel.search(text: sender.text)
    }
    
    @objc func textFieldEdited(_ sender: UITextField) {
        guard let text = sender.text, text != "" else { return }
        
        OlchaGlobalDefaults.search.add(history: text)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != "" else { return true }
        
        coordinator?.pushProductList(search: text)
        
        return true
    }
    
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        viewModel
            .$products
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.products = data ?? []
                tableReload()
            }.store(in: &bag)
        
        viewModel
            .$brands
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.brands = data ?? []
                tableReload()
            }.store(in: &bag)
        
        viewModel
            .$categories
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.categories = data ?? []
                tableReload()
            }.store(in: &bag)
        
        viewModel
            .$searchState
            .sink { [weak self] state in
                guard let self else { return }
                checkSearch(state: state)
            }.store(in: &bag)
        
        placeholderButton { [weak self] in
            guard let self = self else { return }
            popToMainTab(mainTabIndex: OlchaTab.home)
        }
        
    }

    override func initialRequest() {
        if let text = forcedSearchQuery {
            textField().text = text
            OlchaGlobalDefaults.search.add(history: text)
            viewModel.search(text: text)
        }
    }
    
    func textField() -> UITextField {
        navigation.search.searchView.textField
    }
    
    private func tableReload() {
        table.reloadData()
    }
    
    private func checkSearch(state: SearchState) {
        switch state {
        case .loaded:
            isEmpty ? enablePlaceholder() : disablePlaceholder()
            hideCenterProgress()
        case .loading:
            disablePlaceholder()
            showCenterProgress()
        case .notFilled:
            disablePlaceholder()
            hideCenterProgress()
        }
    }
}
