//
//  CartVariationPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 12/11/22.
//

import UIKit
import Combine
import OlchaUI
public enum ProductType {
    case product
    case storeProduct
}
open class CartVariationPage: BaseViewController, ModalPageType {
    
    
    //MARK: - UI elements
    private let table = UITableView()
    //MARK: - Logic
    private var bag = Set<AnyCancellable>()
    let pushProductObserver = PassthroughSubject<ProductModel?, Never>()
    let variationError = PassthroughSubject<Bool, Never>()
    let goCartObserver = PassthroughSubject<Bool, Never>()
    let preOrderObserver = PassthroughSubject<ProductModel?, Never>()
    let goProductObserver = PassthroughSubject<Bool, Never>()
    //MARK: - Responses
    var fullProduct: FullProductData?
    var product: ProductModel?
    
    //MARK: - Coordinator
    weak var coordinator: CartCoordinatorProtocol?
    
    //MARK: - ViewModels
    private let viewModel = ProductViewModel()
    let helper = VariationHelper()
    let filters = ProductListFilters()
    let productHelper = ProductHelper()
    
    enum Section {
        case header
        case actions
        case openProduct
        case variations
    }
    
    public enum OpenType {
        case cart
        case comeBack
    }
    
    let sections : [Section] = [
        .header,
        .actions,
        .openProduct,
        .variations
    ]
    
    var productType: ProductType = .product
    var openType: OpenType = .cart
    
    public var completion: ((ProductModel?) -> Void)?
    
    public override func viewDidLoad() {
        
        setupModalViews()
        modalAutolayout()
        configureModalViews(header: "select_variation".localized())
        setupObservers()
        initialRequest()
        
    }
    
    
    public override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(table)
    }
    
    public override func modalAutolayout() {
        super.modalAutolayout()
        setContainerHeight(UIScreen.main.bounds.height * 0.5)
        table.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
        }
    }
    
    public override func configureModalViews(header: String, textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        dismissConfiguration()
        
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: CartVariationActionsRoom.self)
        table.registerClass(forCell: CartVariationHeaderRoom.self)
        table.registerClass(forCell: CartVariationGoProductRoom.self)
        table.registerClass(forCell: VariationsRoom.self)
    }
    
    
    public override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        productHelper
            .pushProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.pushProductPage(product: data)
            }.store(in: &bag)
        
        goCartObserver
            .sink { [weak self] isPushing in
                guard let self = self, isPushing else { return }
                self.coordinator?.changeCartTab()
            }.store(in: &bag)
        
        preOrderObserver.sink { [weak self] data in
            guard let self = self else { return }
            self.coordinator?.presentSimpleBuy(product: data, type: .preOrder)
        }.store(in: &bag)
        
        pushProductObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                self.coordinator?.pushProductPage(product: model)
            }.store(in: &bag)
        
        goProductObserver.sink { [weak self] isPushing in
            guard let self = self, isPushing else { return }
            dismiss(animated: true) {
                self.completion?(self.product)
            }
            
        }.store(in: &bag)
        
        handle(viewModel.$variationsData, success: { [weak self] data in
            guard let self, let data else { return }
            helper.variationResultData(data: data)
            table.reloadData()
        })
        
        handle(viewModel.$fullProduct, success: { [weak self] data in
            guard let self, let data else { return }
            fullProduct = data
            product = data.product
            product?.store_id = product?.store?.id
            loadVariations()
            MetricEvents.shared.openPageEvent(product, ProductPage.self)
            table.reloadData()
        })
        
        
        helper.productLoader.sink { [weak self] alias in
            guard let self = self else { return }
            self.loadProduct(with: alias)
        }.store(in: &bag)
        
        helper.productLoaderError.sink { [weak self] error in
            guard let self = self else { return }
            self.viewModel.errorMessage = error
        }.store(in: &bag)
        
        variationError.sink { [weak self] isError in
            guard let self = self, isError else { return }
            self.showWarning(text: "select_product".localized())
        }.store(in: &bag)
    }
    
    public override func initialRequest() {
        loadVariations()
        loadProduct()
    }
    
    public func loadVariations() {
        switch productType {
        case .product:
            if let id = self.product?.id {
                viewModel.loadVariations(productID: id)
            }
        case .storeProduct:
            if let id = self.product?.id,
               let storeID = self.product?.getStoreID() {
                viewModel.loadVariations(productID: id, storeID: storeID)
            }
        }
    }
    
    public func loadProduct() {
        if let id = self.product?.id {
            viewModel.loadProductID(id)
            filters.alias = product?.alias ?? ""
        }
    }
    
    
    public func loadProduct(with alias: String) {
        filters.alias = alias
        viewModel.loadProductAlias(alias)
    }

    
    public func emptyVariation() {
        table.setContentOffset(.zero, animated: true)
        showWarning(text: "select_product".localized())
    }
}
