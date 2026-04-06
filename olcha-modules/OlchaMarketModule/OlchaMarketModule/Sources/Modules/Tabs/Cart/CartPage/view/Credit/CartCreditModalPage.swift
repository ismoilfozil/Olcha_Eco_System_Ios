//
//  CartCreditModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/10/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaBalance

class CartCreditModalPage: BaseViewController {
    
    private let storesTable = BaseTableView()
    private let acceptButton = OlchaButton()
    
    var products: [ProductModel] = []
    
    private var bag = Set<AnyCancellable>()
    
    let checkButtonState = PassthroughSubject<Bool, Never>()
    
    weak var observers: CartObservers?
    
    weak var balanceViewModel: BalanceViewModel? {
        didSet {
            setupOptioanlObservers()
        }
    }
    
    var creditOrder = CreditOrder()
    
    let viewModel = CreditViewModel()
    
    var isProductsUpdated = false
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
        storesTable.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(acceptButton.snp.top).inset(-16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        acceptButton.setTitle("accept".localized())
        
        storesTable.delegate = self
        storesTable.dataSource = self
        storesTable.registerClass(forCell: OlchaCreditStoreRoom.self)
        storesTable.registerClass(forCell: AnorbankCreditStoreRoom.self)
        storesTable.configure()
    }
    
    override func setupObservers() {
        acceptButton
            .settings
            .clicked { [weak self] in
                guard let self = self else { return }
                self.observers?.credit = self.creditOrder
                self.dismiss(animated: true) {
                    self.observers?.action.calculateFinished.send(self.creditOrder)
                }
            }
        
        checkButtonState.sink { [weak self] isEnable in
            guard let self = self else { return }
            isEnable ? self.acceptButton.enableButton() : self.acceptButton.disableButton()
        }.store(in: &bag)

    }
    
    func setupOptioanlObservers() {
        guard let balanceViewModel = balanceViewModel else { return }
        
        handle(balanceViewModel.$balance,
               withError: false,
               success: { [weak self] data in
            guard let self else { return }
            storesTable.reloadData()
        })
        
    }
    
    override func initialRequest() {
        updateProducts()
    }
    

    func updateProducts() {
        creditOrder = observers?.credit ?? .init()
        storesTable.reloadData()
    }
}
