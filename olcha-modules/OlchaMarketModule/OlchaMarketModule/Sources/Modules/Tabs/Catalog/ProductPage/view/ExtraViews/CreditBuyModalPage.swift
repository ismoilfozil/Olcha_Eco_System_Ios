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
        case externalProviders
    }
    
    
    private let storesTable = BaseTableView()
    private let acceptButton = OlchaButton()
    private var creditCount: Int = 1
    
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

    let checkoutViewModel = CheckoutViewModel()
    var selectedExternalProvider: ExternalInstallmentProvider?
    var selectedExternalPeriod: Int = 0
    var sharedPeriod: Int?
    
    let sections: [Section] = [
        .products,
        .credits,
        .externalProviders
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
        modalContainer.addSubview(acceptButton)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        setContainerHeight()
        staticLayouts()
    }
    
    private func staticLayouts() {
        acceptButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }

        storesTable.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.bottom.equalTo(acceptButton.snp.top).offset(-16)
        }
    }
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)

        acceptButton.setTitle("checkout".localized())

        storesTable.configure()
        storesTable.delegate = self
        storesTable.dataSource = self
        storesTable.registerClass(forCell: OlchaCreditStoreRoom.self)
        storesTable.registerClass(forCell: CreditCountProductRoom.self)
        storesTable.registerClass(forCell: AnorbankCreditStoreRoom.self)
        storesTable.registerClass(forCell: ExternalInstallmentStoreRoom.self)
        storesTable.separatorStyle = .none
        storesTable.isScrollEnabled = true
        
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
        
        acceptButton.settings.clicked { [weak self] in
            guard let self else { return }
            self.acceptClickObserver.send(self.creditCount)
        }

        isReadyAccept.sink { [weak self] isReady in
            guard let self else { return }
            isReady ? self.acceptButton.enableButton() : self.acceptButton.disableButton()
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
                self.creditCount = count
                self.product?.cart_count = count
                self.product?.creditQuantity = count
                if let provider = self.selectedExternalProvider,
                   let period = self.currentInstallmentPeriod(),
                   provider.sortedPeriods.contains(period) {
                    self.updateExternalInstallment(provider: provider, period: period)
                }
                self.updateProducts()
            }.store(in: &bag)

        checkoutViewModel
            .$externalProviders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                if let section = self.sections.firstIndex(of: .externalProviders) {
                    self.storesTable.reloadSections(IndexSet(integer: section), with: .none)
                }
            }.store(in: &bag)
        
        
    }
    
    override func initialRequest() {
        updateProducts()
        checkoutViewModel.loadExternalProviders()
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

    func totalInstallmentPrice() -> Double {
        (product?.total_price?.double ?? 0) * creditCount.double
    }
    
    func supportedPeriod(for provider: ExternalInstallmentProvider) -> Int? {
        guard let period = currentInstallmentPeriod(),
              provider.sortedPeriods.contains(period) else { return nil }
        return period
    }
    
    func currentInstallmentPeriod() -> Int? {
        if let sharedPeriod { return sharedPeriod }
        if selectedExternalPeriod > 0 { return selectedExternalPeriod }
        if let olchaPeriod = creditOrder.creditDatas[.olcha]?.inst_pay_time, olchaPeriod > 0 { return olchaPeriod }
        guard let product else { return nil }
        let viewModel = CreditViewModel()
        viewModel.calculateStatics(products: [product])
        return viewModel.month > 0 ? viewModel.month : nil
    }
    
    func isOlchaBestOffer() -> Bool {
        guard let period = currentInstallmentPeriod(),
              let olchaTotal = olchaTotalPayment(period: period) else { return false }
        let externalTotals = checkoutViewModel.externalProviders.compactMap { provider -> Double? in
            guard provider.sortedPeriods.contains(period) else { return nil }
            return provider.totalPayment(totalPrice: totalInstallmentPrice(), period: period)
        }
        guard externalTotals.isEmpty == false else { return false }
        return externalTotals.allSatisfy { olchaTotal < $0 }
    }
    
    func updateExternalInstallment(provider: ExternalInstallmentProvider, period: Int) {
        selectedExternalProvider = provider
        selectedExternalPeriod = period
        sharedPeriod = period
        creditOrder.externalInstalment = ExternalInstallmentData(
            alias: provider.checkoutAlias,
            period: period,
            monthlyPayment: provider.monthlyPayment(totalPrice: totalInstallmentPrice(), period: period).int
        )
    }
    
    private func olchaTotalPayment(period: Int) -> Double? {
        guard let product else { return nil }
        let viewModel = CreditViewModel()
        viewModel.calculateStatics(products: [product])
        guard period >= viewModel.minMonth, period <= viewModel.maxMonth else { return nil }
        viewModel.month = period
        if let creditData = creditOrder.creditDatas[.olcha] {
            viewModel.initialPayment = viewModel.getTrueInitialPayment(payment: creditData.first_fee_sum.double)
        }
        viewModel.calculate(products: [product])
        return viewModel.allPayment
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
