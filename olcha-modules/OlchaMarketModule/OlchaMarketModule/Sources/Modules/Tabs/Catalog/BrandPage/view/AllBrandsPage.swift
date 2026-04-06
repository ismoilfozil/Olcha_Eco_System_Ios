//
//  AllBrandsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/08/22.
//

import UIKit
import Combine
import OlchaUI
class AllBrandsPage: BaseViewController {

    let table = BaseTableView()
    
    let staticSections: [Section] = [
        .keyboard,
        .popular
    ]
    
    var sections: [Section] = []
    
    private var bag = Set<AnyCancellable>()
    private let catalogViewModel = CatalogPageViewModel()
    private let viewModel = BrandPageViewModel()
    
    var popularBrands : ManufacturersData?
    
    var letterBrands: [LetterBrandModel] = []
    
    //MARK: - Observers
    let pushCategoryObserver = PassthroughSubject<(CategoryModel?, Manufacturer?), Never>()
    let pushBrandObserver = PassthroughSubject<Manufacturer?, Never>()
    
    
    weak var coordinator: BrandsCoordinatorProtocol?
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(table)
    }
    
    override func autolayout() {
        super.autolayout()
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        navigation.setTitle("all_brands".localized())
        table.configure()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: KeyboardFilterRoom.self)
        table.registerClass(forCell: SingleBrandsRoom.self)
        table.registerClass(forCell: BrandsListRoom.self)
        
        letterBrands = viewModel.getLetterBrands()
        
        sections = staticSections
        sections.append(contentsOf: [Section](repeating: .brands, count: letterBrands.count))
        
        table.reloadData()
    }
    
    override func initialRequest() {
        super.initialRequest()
        catalogViewModel.loadCategoryBrands()
        loadBrands(at: 0)
        loadBrands(at: 1)
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        catalogViewModel
            .$brands
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.popularBrands = data
                self.table.reloadData()
            }.store(in: &bag)
        
        viewModel
            .$brands
            .dropFirst()
            .sink { [weak self] value in
                guard let self = self,
                      let index = value?.0
                else {
                    return
                }
                if index < self.letterBrands.count {
                    self.letterBrands[index].brands = value?.1?.manufacturers ?? []
                    self.table.reloadSections(.init(integer: self.staticSections.count + index), with: .fade)
                }
            }.store(in: &bag)
        
        viewModel
            .$brandsErrorIndex
            .dropFirst()
            .sink { [weak self] index in
                guard let self = self,
                      let index = index else { return }
                self.table.changeState(at: index, state: .notLoaded)
            }.store(in: &bag)
        
        pushCategoryObserver
            .sink { [weak self] value in
                guard let self = self,
                      let category = value.0 else { return }
                let brand = value.1
                if (category.children?.isEmpty ?? true) {
                    let filters = ProductListFilters()
                    filters.category = category
                    filters.selectedManufacturer = brand
                    self.coordinator?.pushProductsList(filters: filters)
                } else {
                    self.coordinator?.pushCatalogListPage(pageState: .category(category, brand))
                }
            }.store(in: &bag)
        
        pushBrandObserver
            .sink { [weak self] brand in
                guard let self = self,
                      let brand = brand else {
                          return
                      }
                self.coordinator?.pushBrandProducts(filters: ProductListFilters().setStaticManufacturer(brand))
            }.store(in: &bag)
        
    }
    

    func loadBrands(at index: Int) {
        guard
            index > -1,
            index < letterBrands.count,
              !table.isLoaded(at: index)
        else {
            return
        }
        table.changeState(at: index, state: .loaded)
        viewModel.loadLetterBrands(letterBrands[index].letter, index: index)
    }
    
    func pushToLetterBrands(with letter: String) {
        coordinator?.pushLetterBrands(letter: letter)
    }
}
