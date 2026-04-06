//
//  CreditBuyModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/07/22.
//

import UIKit
import Combine
import OlchaAuth
import OlchaUI
///This is not my fault that to create different items for all payment types. There are not unique backend type and design. :-)
///
public enum CreditType {
    case olcha
    case anorbank
    
    var title: String {
        switch self {
        case .olcha:
            return "Olcha"
        case .anorbank:
            return "Anorbank"
        }
    }
}

class CreditBuyModalPage: BaseViewController, ModalPageType {
    
    enum ReloadType {
        case table
        case section
    }
    
    enum Section {
        case products
        case credits
    }
    
    
    private let storesTable = BaseTableView()
    
    var product: ProductModel? {
        didSet {
            product?.creditQuantity = 1
        }
    }
    
    var bag = Set<AnyCancellable>()
    
    let profileViewModel = ProfilePageViewModel()
    
    weak var coordinator: ProductCoordinatorProtocol?
    
    let creditOrder = CreditOrder()
    
    //MARK: Observers
    let isReadyAccept = PassthroughSubject<Bool, Never>()
    let tableReloader = PassthroughSubject<ReloadType, Never>()
    let acceptClickObserver = PassthroughSubject<Int, Never>()
    let countObserver = PassthroughSubject<Int, Never>()
    
    var isProductsUpdated = false
    
    let sections: [Section] = [
        .products,
        .credits
    ]
    #warning("anorbank disabled")
    let creditTypes: [CreditType] = [
        .olcha,
//        .anorbank
    ]
    
    override func viewDidLoad() {
        
        setupModalViews()
        modalAutolayout()
        configureModalViews(header: "installment_buy".localized())
        setupObservers()
        initialRequest()
    }
    
    override func setupModalViews() {
        super.setupModalViews()
        
        modalContainer.addSubview(storesTable)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        setContainerHeight()
        staticLayouts()
    }
    
    private func staticLayouts() {
    
        storesTable.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        
        storesTable.delegate = self
        storesTable.dataSource = self
        storesTable.registerClass(forCell: OlchaCreditStoreRoom.self)
        storesTable.registerClass(forCell: CreditCountProductRoom.self)
        storesTable.registerClass(forCell: AnorbankCreditStoreRoom.self)
        storesTable.separatorStyle = .none
        storesTable.isScrollEnabled = true
        storesTable.estimatedRowHeight = 206
        storesTable.rowHeight = UITableView.automaticDimension
        
    }
    
    override func setupObservers() {
        tableReloader.sink { [weak self] type in
            guard let self = self else { return }
            if type == .section {
                self.storesTable.reloadSections(IndexSet(integer: 0), with: .fade)
            } else {
                self.storesTable.reloadData()
            }
        }.store(in: &bag)
        
        acceptClickObserver.sink { [weak self] count in
            guard let self = self,
                  let product = self.product else { return }
            
            if !OlchaGlobalDefaults.isCreditVerified() && AuthGlobalDefaults.isUser() {
                
                self.coordinator?.presentCartVerification {
                    self.addToCart(product: product, count: count)
                }
                
            } else {
                self.addToCart(product: product, count: count)
            }
            
        }.store(in: &bag)
        
        
        countObserver
            .sink { [weak self] count in
                guard let self = self else { return }
                self.product?.cart_count = count
                self.updateProducts()
            }.store(in: &bag)
        
        
    }
    
    override func initialRequest() {
        updateProducts()
    }
    
    private func updateProducts() {
        isProductsUpdated = true
        storesTable.performBatchUpdates { [weak self] in
            guard let self = self else { return }
            self.storesTable.reloadData()
        } completion: { [weak self] isFinished in
            guard let self = self, isFinished else { return }
            self.isProductsUpdated = false
        }

    }

    
    private func addToCart(product: ProductModel, count: Int) {
        self.showCenterProgress()
        CartViewModel.shared.cartChangeCount(productID: product.id,
                                             storeID: product.getStoreID(),
                                             quantity: nil,
                                             addQuantity: count,
                                             type: .plus) { [weak self] in
            guard let self = self else { return }
            self.hideCenterProgress()
            self.dismiss(animated: true, completion: nil)
            self.coordinator?.pushCreditBuy(data: self.creditOrder)
        }
        
        
    }
}
