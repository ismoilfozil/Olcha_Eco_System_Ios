//
//  PhonePaymentViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 12/04/23.
//

import UIKit
import OlchaUI
import IQKeyboardManagerSwift
import OlchaUtils
public class PhonePaymentViewController: BaseViewController<BackNavigationBar> {

    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 16
        scrollView.settings.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        scrollView.settings.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var cardSelectView: CardSelectView = {
        let view = CardSelectView()
        return view
    }()
    
    lazy var phoneField: TField = {
        let field = TField()
        field.type = .shortPhone
        field.topHint = "phone_number".localized()
        return field
    }()
    
    lazy var amountField: TField = {
        let field = TField()
        field.topHint = "summa".localized()
        return field
    }()
    
    lazy var acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("pay".localized())
        return button
    }()
    
    lazy var fields = [
        phoneField,
        amountField
    ]
    
    var serviceFields: [ServiceFieldModel] = []
    
    var phone: String = "" {
        didSet {
            phoneField.setValue(string: phone)
            checkPhoneCode()
        }
    }
    
    weak var coordinator: PaymentsCoordinatorProtocol?
    
    var phoneCodes: [KeyValueModel] = [] {
        didSet {
            checkPhoneCode()
        }
    }
    
    var paymentHelper = MakePaymentHelper() {
        didSet {
            selectDefaultCardHelper.paymentHelper = paymentHelper
        }
    }
    
    let bankCardsViewModel: BankCardsViewModel
    
    let makeTransactionViewModel: MakeTransactionViewModel
    
    let paymentsViewModel: PaymentsViewModel
    
    let selectDefaultCardHelper: SelectDefaultCardHelper
    
    public init(bankCardsViewModel: BankCardsViewModel,
                makeTransactionViewModel: MakeTransactionViewModel,
                paymentsViewModel: PaymentsViewModel
    ) {
        self.makeTransactionViewModel = makeTransactionViewModel
        self.paymentsViewModel = paymentsViewModel
        self.bankCardsViewModel = bankCardsViewModel
        
        self.selectDefaultCardHelper = SelectDefaultCardHelper(
            bankCardsViewModel: self.bankCardsViewModel,
            paymentHelper: self.paymentHelper
        )
        
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(cardSelectView)
        scrollView.addArrangedSubview(phoneField)
        scrollView.addArrangedSubview(amountField)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        cardSelected()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
    }
    
    public override func initialRequest() {
        paymentsViewModel.loadPhoneCodes()
        selectDefaultCardHelper.loadBankCards()
        checkButtonState()
    }
    
    public override func setupObservers() {
        networkObservers()
        observerHelper()
    }
    
}
// MARK: - OBSERVERS
extension PhonePaymentViewController {
    
    func checkButtonState() {
        let isEnabled = phoneField.isValidated() && amountField.isValidated() && (paymentHelper.selectedCard != nil)
         isEnabled ? acceptButton.enableButton() : acceptButton.disableButton()
    }
    
    func networkObservers() {
        handle(paymentsViewModel.$phoneCodes,
               showLoader: false,
               success: { [weak self] data in
            guard let self = self else { return }
            self.phoneCodes = data?.codes ?? []
        })
        
        handle(makeTransactionViewModel.$makeTransaction) { [weak self] data in
            guard let self = self else { return }
            coordinator?.pushVerifyPayment(verifyData: data, makePaymentHelper: paymentHelper)
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showError(text: error?.message)
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.acceptButton.settings.requesting = isLoading
        }
        
        handle(paymentsViewModel.$provider,
               showLoader: true,
               success: { [weak self] data in
            guard let self = self else { return }
            self.paymentHelper.provider = data?.providers
        })
    }
    
    func cardSelected() {
        cardSelectView.setup(card: paymentHelper.selectedCard)
        setupAmountRules()
        checkButtonState()
    }
    
    func providerUpdated() {
        navigationBar.setTitle(paymentHelper.provider?.title_short)
        paymentHelper.service = paymentHelper.provider?.service?.first(where: { $0.id == paymentHelper.serviceID } )
    }
    
    func serviceUpdated() {
        serviceFields = paymentHelper.service?.services_field ?? []
        setupAmountRules()
    }
    
    func observerHelper() {
        paymentHelper.observers.selectedCard.sink { [weak self] isAction in
            guard let self = self, isAction else { return }
            self.navigationController?.dismissPresentedViewController()
            self.cardSelected()
        }.store(in: &bag)
        
        paymentHelper.observers.providerUpdated.sink { [weak self] isAction in
            guard let self = self, isAction else { return }
            self.providerUpdated()
        }.store(in: &bag)
        
        paymentHelper.observers.serviceUpdated.sink { [weak self] isAction in
            guard let self = self, isAction else { return }
            self.serviceUpdated()
        }.store(in: &bag)
        
        acceptButton.clicked { [weak self] in
            guard let self = self else { return }
            self.makeTransaction()
        }
        
        phoneField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkPhoneCode()
            self.checkButtonState()
        }
        
        amountField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        cardSelectView.button.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.presentMyBankCards(makePaymentHelper: self.paymentHelper)
        }
        
        selectDefaultCardHelper.cardSelectedObserver = { [weak self] in
            guard let self = self else { return }
            cardSelected()
        }
    }
    
    func setupAmountRules() {
        amountField.type = .amountRanged(range: (min: paymentHelper.service?.min_amount,
                                                 max: paymentHelper.service?.max_amount))
        amountField.append(rule: TextFieldRules.shared.maxCashRule(max: paymentHelper.getSelectedCardAmount()))
    }
}

// MARK: - REQUESTS
extension PhonePaymentViewController {
    func loadProvider() {
        guard let serviceID = paymentHelper.serviceID else { return }
        paymentsViewModel.loadProvider(serviceID: serviceID)
    }
    
    func makeTransaction() {
        
        let phoneServiceField = serviceFields.first(where: { $0.getType() == .phone })
        let amountServiceField = serviceFields.first(where: { $0.getType() == .money })
    
        paymentHelper.fields = [
            
            TransactionKeyValueModel(key: phoneServiceField?.name,
                                     value: phoneField.getValue(),
                                     is_money: false,
                                     type: phoneServiceField?.type),
            
            TransactionKeyValueModel(key: amountServiceField?.name,
                                     value: amountField.getValue(),
                                     is_money: true,
                                     type: amountServiceField?.type)
            
        ]
        
        makeTransactionViewModel.makeTransaction(helper: paymentHelper)
    }
    
    func checkPhoneCode() {
        let phone = phoneField.getValue()
        let code = phone.prefix(2)
        
        if let serviceID = phoneCodes.first(where: { ($0.key ?? "-1") == code })?.value?.int {
            if serviceID != paymentHelper.serviceID {
                paymentHelper.serviceID = serviceID
                loadProvider()
            }
        } else {
            paymentHelper.resetProvider()
        }
    }
}
