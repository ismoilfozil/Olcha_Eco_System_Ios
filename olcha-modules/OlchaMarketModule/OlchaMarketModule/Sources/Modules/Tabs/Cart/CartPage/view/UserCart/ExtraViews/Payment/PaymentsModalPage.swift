//
//  PaymentsModalPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 07/02/24.
//

import OlchaUI
import UIKit
import OlchaUtils

class PaymentsModalPage: BaseModalViewController {
    
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: PaymentRoom.self)
        table.registerClass(forCell: BalanceFillRoom.self)
        
        return table
    }()
    
    private let saveButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("save".localized())
        return button
    }()
    
    var paymentTypesData: PaymentTypeData?
    
    var payments: [Payments] = []
    var paymentSystems: [Payments] = []
    
    var allPayments: [Payments] {
        var newPayments: [Payments] = []
        newPayments.append(contentsOf: payments)
        newPayments.append(contentsOf: paymentSystems)
        return newPayments
    }
    
    weak var observers: CartObservers?
    
    weak var checkoutViewModel: CheckoutViewModel?
    
    var selectedPayment: Payments?
    
    override func setupViews() {
        container.addSubview(table)
        container.addSubview(saveButton)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(30)
            make.top.equalTo(table.snp.bottom).inset(-50)
        }
    }
    
    override func configureViews() {
        setHeader(title: "payment_type".localized())
        xButton.isHidden = true
    }
    
    override func setupObservers() {
        saveButton.clicked { [weak self] in
            guard let self else { return }
            observers?.selectedPayment = selectedPayment
            observers?.action.paymentSelected.send()
            dismiss(animated: true)
        }
    }
    
    override func setupOptionalObservers() {
        self.selectedPayment = observers?.selectedPayment
        
        guard let checkoutViewModel else { return }
        checkoutViewModel
            .$paymentTypes
            .sink { [weak self] data in
                guard let self else { return }
                observers?.paymentTypes = data
                setup(with: data)
                table.reloadData()
            }.store(in: &bag)
    }
    
    override func setupOptionalInitialRequests() {
        table.reloadData()
    }
    
    func setup(with data: PaymentTypeData?) {
        self.payments = data?.payments ?? []
        self.paymentSystems = data?.paymentSystems ?? []
    }
    
}
