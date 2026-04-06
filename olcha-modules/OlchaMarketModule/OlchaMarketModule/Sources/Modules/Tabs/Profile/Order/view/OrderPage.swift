//
//  OrderPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 21/10/22.
//

import UIKit
import OlchaUI
import OlchaBankCards
import Combine
import OlchaBalance
import OlchaUtils
class OrderPage: BaseViewController {
    
    enum Section {
        case data
        case products
        case anorbankVerify
        case pay
        case payments
        case payAll
        case graph
    }
    
    var bag = Set<AnyCancellable>()
    
    private let table = BaseTableView()
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    let sections: [Section] = [
        .data,
        .products,
        .anorbankVerify,
        .pay,
        .payments,
        .payAll,
        .graph
    ]
    
    var orderDataModels: [ OrderDataModel ] = [
        .type(""),
        .date(""),
        .price(""),
        .contact(""),
        .phone(""),
        .location("")
    ]
    
    private lazy var bankCardViewModel: BankCardViewModel = BankCardsDIContainer.shared.resolve()
    
    let orderViewModel = OrderPageViewModel()
    
    private let checkoutViewModel = CheckoutViewModel()
    
    let balanceViewModel: BalanceViewModel = BalanceDIContainer.shared.resolve()
    
    let observer = OrderPaymentObserver()
    
    let productHelper = ProductHelper()
    
    // MARK: - properties
    var creditGraphPayments: [InstallmentResultData] = []
    
    var detail: InstallmentDetail?
    
    var order: Order?
    
    var bankCards: [BankCard] = []
    
    var balance: Balance?
    
    var payments: [Payments] = []
    
    let verifyObserver = PassthroughSubject<Bool, Never>()
    
    let balanceFilled = PassthroughSubject<Void, Never>()
    
    var isOpenedProducts: [IndexPath: Bool] = [:]
    
    override func setupViews() {
        container.addSubview(table)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        navigation.configure(style: .back)
        navigation.setTitle("order_num".localized() + (order?.id ?? 0).string)
        navigation.setSubtitle(order?.created_at?.day_month ?? "от 24 февраля")

        navigation.back.searchButton.setIcon(.qr_check)
        navigation.back.searchButton.isHidden = true
        
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: OrderDataRoom.self)
        table.registerClass(forCell: OrderPaymentProductRoom.self)
        table.registerClass(forCell: OrderPaymentsRoom.self)
        table.registerClass(forCell: PayAllRoom.self)
        table.registerClass(forCell: PaymentGraphRoom.self)
        table.registerClass(forCell: OrderPayRoom.self)
        table.registerClass(forCell: AnorbankVerifyRoom.self)
        table.registerClass(forCell: ComponentHeader.self)
        
        table.configure()
        
        
        fillWithData()
     
        table.contentInset = .init(top: 16, left: 0, bottom: 32, right: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialLoads()
    }
    
    func initialLoads() {
        bankCardViewModel.loadBankCards()
        
        balanceViewModel.loadBalance()
        
        checkoutViewModel.loadPaymentTypes(regionID: order?.region?.id ?? 0,
                                           withoutBalance: true)
        
        orderViewModel.loadOrder(orderID: order?.id)
    }
    
    override func setupObservers() {
        baseSetupObservers(viewModel: orderViewModel)
        
        handle(bankCardViewModel.$cards, withError: false, success: { [weak self] data in
            guard let self = self else { return }
            self.bankCards = data ?? []
            self.table.reloadData()
        })
        
        handle(balanceViewModel.$balance, withError: false, success: { [weak self] data in
            guard let self = self else { return }
            self.balance = data?.platformBalance
            self.table.reloadData()
        })
        
        checkoutViewModel
            .$paymentTypes
            .sink { [weak self] data in
                guard let self = self else { return }
                self.payments = data?.paymentSystems ?? []
                self.table.reloadData()
            }.store(in: &bag)
        
        orderViewModel
            .paymentSuccess
            .sink { [weak self] isSuccess in
                guard let self = self else { return }
                self.initialLoads()
            }.store(in: &bag)
        
        orderViewModel
            .$order
            .sink { [weak self] data in
                guard let self = self,
                      let data = data else { return }
                
                self.order = data
                
                self.creditGraphPayments = data.graphs ?? []
                
                var totalDebtPayments = 0
                
                data.graphs?.forEach {
                    if $0.status != "success" {
                        totalDebtPayments += ($0.payment?.int ?? 0)
                    }
                }
                
                self.observer.totalPayment = totalDebtPayments.string
                
                self.observer.nextPayment = data.graphs?.first { $0.status != "success" }?.payment ?? ""
                
                self.observer.payment = self.observer.nextPayment
                
                self.fillWithData()
            }.store(in: &bag)
        
        orderViewModel
            .$paymentURLData
            .sink { [weak self] data in
                guard let self = self, let data = data else { return }
                self.coordinator?.pushOrderPay(urlString: data.redirectUrl ?? "")
            }.store(in: &bag)
        
        observer.isSelected.sink { [weak self] isSelected in
            guard let self = self, isSelected else { return }
            self.table.reloadData()
        }.store(in: &bag)
        
        observer.tableReloader.sink { [weak self] isReloading in
            guard let self = self, isReloading else { return }
            self.table.reloadData()
        }.store(in: &bag)
        
        verifyObserver.sink { [weak self] isVerified in
            guard let self = self else { return }
            self.showSuccess(text: "anorbank_verified_successfully".localized())
            self.orderViewModel.loadOrder(orderID: self.order?.id)
        }.store(in: &bag)
        
        productHelper
            .pushProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.pushProduct(product: data)
            }.store(in: &bag)
        
        observer.balanceFill.sink { [weak self] in
            guard let self else { return }
            coordinator?.pushFillBalance(balanceFilled: balanceFilled)
        }.store(in: &bag)
        
        balanceFilled.sink { [weak self] isFilled in
            guard let self = self else { return }
            balanceViewModel.loadBalance()
        }.store(in: &bag)
    }
    
    func payClicked() {
        switch observer.selectedPayment {
        case .balance:
            orderViewModel.balancePay(amount: observer.payment,
                                      order_id: order?.id)
            break
        case .card(let bankCard):
            orderViewModel.cardPay(amount: observer.payment,
                                   card_id: bankCard.id,
                                   orderID: order?.id)
            break
        case .payment(let payment):
            orderViewModel.loadInstallmentPaymentURL(orderID: order?.id,
                                                     payment: observer.payment,
                                                     paymentType: payment?.alias)
            break
        default: break
        }
    }
    
    private func fillWithData() {
        orderDataModels = [
            .type(((order?.is_installment ?? false) ? "monthly_buy" : "cash_buy".localized()).localized() ),
            .date(order?.created_at ?? " - "),
            .price(order?.total_price_all?.string.originalPrice ?? " - "),
            .contact(order?.name ?? " - "),
            .phone(order?.phone ?? " - "),
            .location(order?.full_address ?? " - ")
        ]
        table.reloadData()
    }
}
