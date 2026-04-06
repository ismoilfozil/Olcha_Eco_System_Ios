//
//  AddBasketModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/07/22.
//

import UIKit
import Combine
import OlchaUI
class AddBasketModalPage: BaseViewController, ModalPageType {
    
    //MARK: - UI elements
    private let productContainer = BasketProduct()
    
    private let actionButtonsContainer = UIStackView()
    private let addCartButton = CartButton()
    private let goBasketButton = Button()
    private let separator = UIView()
    private let table = UITableView()
    //MARK: - Logic
    weak var catalogViewModel: CatalogPageViewModel?
    private var bag = Set<AnyCancellable>()
    let productHelper = ProductHelper()
    
    //MARK: - Responses
    var product: ProductModel?
    var alsoSeenProductsData: ProductsData?
    
    //MARK: - Coordinator
    weak var coordinator: ProductCoordinatorProtocol?
    
    override func viewDidLoad() {
        
        setupModalViews()
        modalAutolayout()
        configureModalViews(header: "product_in_basket".localized())
        setupObservers()
        initialRequest()
    }
    
    //MARK: - Life cycle
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.addObserver(self, forKeyPath: KeyPath.contentSize, options: .new, context: nil)

    }
    override func viewWillDisappear(_ animated: Bool) {
        table.removeObserver(self, forKeyPath: KeyPath.contentSize)
        super.viewWillDisappear(true)
    }

    override func setupModalViews() {
        super.setupModalViews()
        
        modalContainer.addSubview(productContainer)
        modalContainer.addSubview(actionButtonsContainer)
        
        actionButtonsContainer.addArrangedSubview(addCartButton)
        actionButtonsContainer.addArrangedSubview(goBasketButton)
        
        modalContainer.addSubview(separator)
        modalContainer.addSubview(table)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        productContainer.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(16)
        }
        
        actionButtonsContainer.snp.makeConstraints { make in
            make.top.equalTo(productContainer.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(actionButtonsContainer.snp.bottom).inset(-16)
        }
        
        table.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).inset(-16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(0)
        }
    }
    
    override func configureModalViews(header: String, textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        
        dismissConfiguration()
        productContainer.backgroundColor = .clear
        

        
        actionButtonsContainer.axis = .horizontal
        actionButtonsContainer.spacing = 12
        actionButtonsContainer.distribution = .fillEqually
        
        goBasketButton.designAccentButtons("go_basket".localized(), withShadow: false)
        
        
        separator.backgroundColor = .olchaLightNeutralGray
        
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: HorizontalPromotedRoom.self)
        table.registerClass(forCell: ComponentHeader.self)
        
        table.estimatedRowHeight = UITableView.automaticDimension
        table.rowHeight = UITableView.automaticDimension
        table.isScrollEnabled = false
        table.separatorStyle = .none
        fillWithData()
        
        addCartButton.countButton.maxCount = product?.quantity?.int ?? 1
        addCartButton.countButton.disableZero = true
        
        addCartButton.count = product?.cart_count ?? 0
    }
    
    
    override func setupObservers() {
        if let viewModel = catalogViewModel {
            super.baseSetupObservers(viewModel: viewModel)
        } else {
            super.setupObservers()
        }
        if let catalogViewModel {
            handle(catalogViewModel.$similar, success: { [weak self] data in
                guard let self else { return }
                alsoSeenProductsData = data
                table.reloadData()
            })
        }
        
        productHelper
            .pushProduct
            .sink { [weak self] model in
                guard let self = self else { return }
                self.coordinator?.pushProductPage(product: model)
            }.store(in: &bag)
        
        goBasketButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.changeCartTab()
        }
        
        addCartButton
            .countButton
            .$countClicked
            .sink { [weak self] type in
                guard let self = self,
                      self.product?.cart_count != self.addCartButton.count else { return }
                
                MetricEvents.shared.cartEvent(self.product, type: type)
                
                CartViewModel.shared.cartChangeCount(productID: self.product?.id,
                                                     storeID: self.product?.getStoreID(),
                                                     quantity: self.addCartButton.count,
                                                     type: type)
                
            }.store(in: &bag)
        
        CartViewModel
            .shared
            .cartItemChanged
            .sink { [weak self] cartItem in
                guard let self = self else { return }
                if cartItem?.product_id == self.product?.id && cartItem?.store_id == self.product?.getStoreID() {
                    self.product?.cart_count = cartItem?.quantity ?? 0
                    self.addCartButton.count = cartItem?.quantity ?? 0
                }
            }.store(in: &bag)
        
        productHelper
            .pushParentProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.presentCartVariation(product: data, productType: .product)
            }.store(in: &bag)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?){
        if (keyPath == KeyPath.contentSize) {
            if let newvalue = change?[.newKey]{
                if let newsize  = newvalue as? CGSize {
                    let height = newsize.height
                    updateLayout(height: height)
                }
            }
        }
    }
    
    
    private func updateLayout(height: CGFloat) {
        self.table.snp.remakeConstraints { make in
            make.top.equalTo(self.separator.snp.bottom).inset(-16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(height)
        }
    }
    
    private func fillWithData() {
        productContainer.setup(with: product)
        addCartButton.countButton.maxCount = product?.quantity?.int ?? Int.max
    }
}
