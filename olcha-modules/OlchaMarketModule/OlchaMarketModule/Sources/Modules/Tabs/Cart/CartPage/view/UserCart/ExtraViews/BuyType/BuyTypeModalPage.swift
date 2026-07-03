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
import OlchaUtils
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
        table.registerClass(forCell: ExternalInstallmentStoreRoom.self)
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
        .externalProviders
    ]

    var types: [BuyType] = [
        .cash,
    ]

    var selectedBuyType: BuyType? {
        didSet {
            if selectedBuyType != .credit { selectedExternalProvider = nil }
        }
    }

    var selectedExternalProvider: ExternalInstallmentProvider?

    var selectedExternalPeriod: Int = 0
    
    var selectedInstallmentPeriod: Int?
    
    var shouldRestoreExternalProvider = true

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
    weak var checkoutViewModel: CheckoutViewModel?
    
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
            if let ext = selectedExternalProvider {
                creditOrder.externalInstalment = ExternalInstallmentData(
                    alias: ext.checkoutAlias,
                    period: selectedExternalPeriod,
                    monthlyPayment: ext.monthlyPayment(totalPrice: observers?.getTotalPrice() ?? 0,
                                                       period: selectedExternalPeriod).int
                )
                self.observers?.credit = self.creditOrder
                observers?.action.buyTypeSelected.send(.credit)
                self.dismiss(animated: true) {
                    self.observers?.action.calculateFinished.send(self.creditOrder)
                }
                return
            }
            creditOrder.externalInstalment = nil
            self.observers?.credit = self.creditOrder
            observers?.action.buyTypeSelected.send(selectedBuyType ?? .none)
            if selectedBuyType == .credit {
                self.dismiss(animated: true) {
                    self.observers?.action.calculateFinished.send(self.creditOrder)
                }
                return
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
        if let existingExt = observers?.credit?.externalInstalment {
            selectedExternalProvider = checkoutViewModel?.externalProviders.first { $0.checkoutAlias == existingExt.alias }
            selectedExternalPeriod = existingExt.period
            selectedInstallmentPeriod = existingExt.period
        } else if let olchaPeriod = observers?.credit?.creditDatas[.olcha]?.inst_pay_time, olchaPeriod > 0 {
            selectedInstallmentPeriod = olchaPeriod
            shouldRestoreExternalProvider = false
        } else {
            shouldRestoreExternalProvider = false
        }
        creditOrder = observers?.credit ?? .init()

        balanceViewModel?
            .$balance
            .sink { [weak self] data in
                guard let self else { return }
                observers?.limitBalance = data.value?.instalmentBalance
                table.reloadData()
            }.store(in: &bag)

        checkoutViewModel?
            .$externalProviders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                restoreExternalProviderIfNeeded()
                table.reloadData()
            }.store(in: &bag)

        checkoutViewModel?.loadExternalProviders()
    }
    
    private func creditTypeContains() -> Bool {
        observers?.products.contains(where: { $0.plan != nil }) ?? false
    }
    
    func supportedPeriod(for provider: ExternalInstallmentProvider) -> Int? {
        guard let period = currentInstallmentPeriod(),
              provider.sortedPeriods.contains(period) else { return nil }
        return period
    }

    func isOlchaBestOffer() -> Bool {
        guard let period = currentInstallmentPeriod(),
              let olchaTotal = olchaTotalPayment(period: period) else { return false }
        let totalPrice = observers?.getTotalPrice() ?? 0
        let externalTotals = (checkoutViewModel?.externalProviders ?? []).compactMap { provider -> Double? in
            guard provider.sortedPeriods.contains(period) else { return nil }
            return provider.totalPayment(totalPrice: totalPrice, period: period)
        }
        guard externalTotals.isEmpty == false else { return false }
        return externalTotals.allSatisfy { olchaTotal < $0 }
    }

    private func restoreExternalProviderIfNeeded() {
        guard shouldRestoreExternalProvider,
              selectedExternalProvider == nil,
              let existingExt = observers?.credit?.externalInstalment,
              let provider = checkoutViewModel?.externalProviders.first(where: { $0.checkoutAlias == existingExt.alias }) else { return }
        selectedExternalProvider = provider
        selectedExternalPeriod = existingExt.period
        selectedInstallmentPeriod = existingExt.period
        shouldRestoreExternalProvider = false
    }

    private func olchaTotalPayment(period: Int) -> Double? {
        let products = observers?.products ?? []
        guard products.isEmpty == false else { return nil }
        let viewModel = CreditViewModel()
        viewModel.coupon = observers?.coupon?.value?.double ?? 0
        viewModel.bonus = (observers?.isBonusUsing ?? false) ? (observers?.bonus?.usingBonus?.double ?? 0) : 0
        viewModel.calculateStatics(products: products)
        guard period >= viewModel.minMonth, period <= viewModel.maxMonth else { return nil }
        viewModel.month = period
        if let creditData = creditOrder.creditDatas[.olcha] {
            viewModel.initialPayment = viewModel.getTrueInitialPayment(payment: creditData.first_fee_sum.double)
        }
        viewModel.calculate(products: products)
        return viewModel.allPayment
    }

    private func currentInstallmentPeriod() -> Int? {
        if let selectedInstallmentPeriod { return selectedInstallmentPeriod }
        if selectedExternalPeriod > 0 { return selectedExternalPeriod }
        if let olchaPeriod = creditOrder.creditDatas[.olcha]?.inst_pay_time, olchaPeriod > 0 { return olchaPeriod }
        let products = observers?.products ?? []
        guard products.isEmpty == false else { return nil }
        let viewModel = CreditViewModel()
        viewModel.calculateStatics(products: products)
        return viewModel.month > 0 ? viewModel.month : nil
    }

}
