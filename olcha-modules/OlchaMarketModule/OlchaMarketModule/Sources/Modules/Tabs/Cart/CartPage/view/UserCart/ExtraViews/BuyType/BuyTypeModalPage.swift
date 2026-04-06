//
//  BuyTypeModalPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 07/02/24.
//

import UIKit
import OlchaUI
import Combine
import OlchaBalance
enum BuyType: String {
    case credit = "instalment"
    case cash = "purchase"
    case none
    
    var title: String {
        switch self {
        case .credit:
            return "monthly_buy".localized()
        case .cash:
            return "cash_buy".localized()
        default: return ""
        }
    }
    
    var subtitle: String {
        switch self {
        case .credit:
            return ""
        case .cash:
            return ""
        default: return ""
        }
    }
}
class BuyTypeModalPage: BaseModalViewController {
    
   
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: BuyTypeSelectRoom.self)
        table.registerClass(forCell: OlchaCreditStoreRoom.self)
        table.registerClass(forCell: CreditGraphRoom.self)
        return table
    }()
    
    private let saveButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("save".localized())
        return button
    }()
    
    let sections: [Section] = [
        .buyTypes,
        .calculator,
        .graph
    ]
    
    var types: [BuyType] = [
        .cash,
    ]
    
    var selectedBuyType: BuyType?
    
    let itemHeight: CGFloat = 100
    
    var creditOrder = CreditOrder()
    
    var skeleton: Skeleton? {
        observers?.skeleton.buyTypes
    }
    
    let graphObserver = CurrentValueSubject<[String: InstallmentInfo], Never>([:])
    
    var typesCount: Int {
        skeleton?.getCount(types.count) ?? types.count
    }
    
    weak var observers: CartObservers? {
        didSet {
            var newTypes: [BuyType] = []
            if creditTypeContains() {
                newTypes = [.cash, .credit]
            } else {
                newTypes = [.cash]
            }
            types = newTypes
        }
    }
    
    weak var balanceViewModel: BalanceViewModel?
    
    let checkButtonState = PassthroughSubject<Bool, Never>()
        
    override func setupViews() {
        container.addSubview(table)
        container.addSubview(saveButton)
    }
    
    override func autolayout() {
        
        table.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
        
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.top.equalTo(table.snp.bottom).inset(-16)
        }
        
    }
    
    override func configureViews() {
        setHeader(title: "order_type".localized())
        xButton.isHidden = true
    }
    
    override func setupObservers() {
        saveButton.clicked { [weak self] in
            guard let self else { return }
            self.observers?.credit = self.creditOrder
            observers?.action.buyTypeSelected.send(selectedBuyType ?? .none)
            dump(creditOrder.creditDatas[.olcha])
            if selectedBuyType == .credit {
                self.dismiss(animated: true) {
                    self.observers?.action.calculateFinished.send(self.creditOrder)
                }
            }
            dismiss(animated: true)
        }
        
        checkButtonState.sink { [weak self] isEnable in
            guard let self = self else { return }
            isEnable ? saveButton.enableButton() : saveButton.disableButton()
        }.store(in: &bag)
        
    }
    
    override func setupOptionalInitialRequests() {
        table.reloadData()
    }
    
    override func setupOptionalObservers() {
        
        selectedBuyType = observers?.selectedBuyType
        creditOrder = observers?.credit ?? .init()
        guard let balanceViewModel else { return }
        balanceViewModel
            .$balance
            .sink { [weak self] data in
                guard let self else { return }
                observers?.limitBalance = data.value?.instalmentBalance
                table.reloadData()
            }.store(in: &bag)
    }
    
    private func creditTypeContains() -> Bool {
        observers?.products.contains(where: { $0.plan != nil }) ?? false
    }
    
}
