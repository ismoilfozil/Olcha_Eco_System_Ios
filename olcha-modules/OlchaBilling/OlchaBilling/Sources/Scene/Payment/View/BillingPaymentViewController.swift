//
//  BillingPaymentViewController.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 20/06/23.
//

import UIKit
import OlchaUI
import OlchaUtils
import OlchaBankCards
import IQKeyboardManagerSwift

public class BillingPaymentViewController: BaseViewController<TitleNavigationBar> {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        
        table.delegate = self
        table.dataSource = self
        
        table.registerClass(forCell: BillingPaymentHeaderRoom.self)
        table.registerClass(forCell: BillingCardRoom.self)
        table.registerClass(forCell: BillingPaymentHeaderRoom.self)
        table.registerClass(forCell: WebhooksRoom.self)
        table.registerClass(forCell: BalancesRoom.self)
        table.registerClass(forCell: AddBillingCardRoom.self)
        
        table.configure()
        
        return table
    }()
    
    private lazy var amountFieldContainer: UIView = {
        let view = UIView()
        view.round()
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    private let fieldsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    let amountField: TField = {
        let field = TField()
        field.type = .amount
        return field
    }()
    
    public let otpField: OtpField = {
        let field = OtpField()
        field.type = .required
        field.finishTiming()
        return field
    }()
    
    public let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .olchaPrimaryColor
        label.style(.medium, 12)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let currencyContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 2
        stack.isHidden = true
        return stack
    }()
    
    private let currencyTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 16)
        label.numberOfLines = 0
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let currencyValueLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 16)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = .olchaLightTextColornnnnnn
        return label
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    public let payButton = OlchaButton()
    
    private let payAllButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.semibold, 16)
        button.setTitleColor(.olchaPrimaryColor, for: .normal)
        return button
    }()
    
    private let addCardButton: IButton = {
        let button = IButton()
        button.round()
        button.backgroundColor = .olchaPrimaryColor.withAlphaComponent(0.1)
        button.setTitleColor(.olchaPrimaryColor, for: .normal)
        button.titleLabel?.style(.semibold, 16)
        button.isHidden = true
        return button
    }()
    
    public var sections: [Section] {
        var sections: [Section] = []
        
        if input.bankCardsSkeleton.isAnimating {
            sections = [ .card ]
        } else {
            sections = Array(repeating: .card, count: input.bankCardParents.count)
        }
        
        sections.append(contentsOf: [
            .webhook,
            .balance,
        ])
        
        return sections
    }
    
    lazy var keyboardManager = KeyboardManager()
    let viewModel: BillingViewModel
    var input: Input
    var output: Output
    
    weak var coordinator: BillingCoordinatorProtocol?
    
    public init(viewModel: BillingViewModel,
                input: Input = .init(),
                output: Output = .init()) {
        self.input = input
        self.output = output
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = false
        keyboardManager.startObservingKeyboard()
        keyboardManager.keyboardWillShowObserver = keyboardWillShowObserver
        keyboardManager.keyboardWillHideObserver = keyboardWillHideObserver
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
        keyboardManager.stopObservingKeyboard()
    }
    
    private func keyboardWillShowObserver(height: CGFloat, timeInterval: TimeInterval) {
        guard let coordinator, coordinator.navigationController.presentedViewController == nil else { return }
        amountFieldContainer.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(height)
        }
        UIView.animate(withDuration: timeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func keyboardWillHideObserver() {
        amountFieldContainer.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    public override func setupViews() {
        container.addSubview(table)
        container.addSubview(amountFieldContainer)
        amountFieldContainer.addSubview(fieldsStack)
        
        fieldsStack.addArrangedSubview(amountField)
        fieldsStack.addArrangedSubview(otpField)
        fieldsStack.addArrangedSubview(currencyContainer)
        fieldsStack.addArrangedSubview(errorMessageLabel)
        
        currencyContainer.addArrangedSubview(currencyTitleLabel)
        currencyContainer.addArrangedSubview(currencyValueLabel)
        
        amountFieldContainer.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(payButton)
        buttonsStackView.addArrangedSubview(payAllButton)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(amountFieldContainer.snp.top).inset(-16)
        }
        
        amountFieldContainer.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
        }
        
        fieldsStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        amountField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        otpField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        currencyContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        currencyTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        currencyValueLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(fieldsStack.snp.bottom).inset(-24)
            make.left.bottom.right.equalToSuperview().inset(16)
        }
        
        payButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        payAllButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        errorMessageLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        languageUpdated()
        checkButtonState()
        setup()
        
        fieldsStack.setCustomSpacing(2, after: currencyContainer)
        if let currentPayment = input.billingFilter.order.current_value {
            amountField.text = currentPayment.string.originalPriceWithoutCurrency
        }
    }
    
    public override func languageUpdated() {
        amountField.topHint = "amount_pay".localized(.billing)
        payButton.setTitle("pay".localized())
        payAllButton.setTitle("pay_all_button".localized(), for: .normal)
        otpField.topHint = "otp_code".localized(.billing)
        addCardButton.setTitle("add_card".localized(), for: .normal)
        currencyTitleLabel.text = "currency".localized(.billing)
        payButton.disableButton()
    }
    
    public override func setupObservers() {
        amountField.observeTextChanged { [weak self] in
            guard let self = self else { return }
            input.billingFilter.payment.otpState = .default
            amountChanged()
        }
        
        otpField.observeTextChanged { [weak self] in
            guard let self = self else { return }
            checkButtonState()
            checkCurrency()
        }
        
        payAllButton.clicked { [weak self] in
            guard let self = self else { return }
            amountField.setValue(string: input.billingFilter.order.max_value?.string)
            amountChanged()
        }
        
        handle(viewModel.$paymentTypes, success: { [weak self] data in
            guard let self = self else { return }
            input.paymentTypes = data
            table.reloadData()
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            input.webhooksSkeleton.isAnimating = isLoading
            table.reloadData()
        })
        
        handle(viewModel.$balances, success: { [weak self] data in
            guard let self = self else { return }
            input.balances = data?.collection ?? []
            table.reloadData()
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            input.balancesSkeleton.isAnimating = isLoading
            table.reloadData()
        })
        
        handle(viewModel.$bankCards, success: { [weak self] data in
            guard let self = self else { return }
            input.bankCardParents = data?.collection ?? []
            table.reloadData()
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            input.bankCardsSkeleton.isAnimating = isLoading
            table.reloadData()
        })
        
        payButton.clicked { [weak self] in
            guard let self = self else { return }
            payButtonClicked()
        }
        
        addCardButton.clicked { [weak self] in
            guard let self = self else { return }
            coordinator?.presentAddBankCard(
                filter: input.billingFilter,
                loadCards: output.loadCards
            )
        }
        
        otpField.sendPhoneCode { [weak self] in
            guard let self = self else { return }
            sendOtp()
        }
        
        setupPaymentObservers()
    }
    
    public override func initialRequest() {
        loadPaymentTypes()
    }
    
    public func setup() {
        amountField.rules.removeAll()
        let maxValue = input.billingFilter.getMaxAmount().double
        let minValue = input.billingFilter.getMinAmount().double
        
        if maxValue > 0 {
            amountField.currency = input.billingFilter.getPaymentCurrency()
            amountField.type = .amountRanged(
                range: (min: minValue, max: maxValue)
            )
        }
        
        if let currentAmount = input.billingFilter.getCurrentAmount() {
            amountField.append(
                rule: TextFieldRules().maxCashRule(max: currentAmount,
                                                   currency: input.billingFilter.getPaymentCurrency())
            )
        }
        

    }
    ///
    /// - After setting `BillingFilter` to this page you have to ``setupData()``
    ///
    public func setupData() {
        setup()
        let payAllEnabled = ((input.billingFilter.order.max_value ?? 0) > 0)
        
        payAllButton.isHidden = input.billingFilter.isPayAllButtonHidden || !payAllEnabled
        amountField.isUserInteractionEnabled = !input.billingFilter.isAmountFieldDisabled
        amountField.enableGrayView = input.billingFilter.isAmountFieldDisabled
        amountField.text = input.billingFilter.amount?.string.originalPriceWithoutCurrency
    }
    
    public func itemSelected() {
        setup()
        table.reloadData()
        checkButtonState()
        otpFieldChanged()
        loadCurrency()
    }
    
    public func setupCurrency() {
        
        guard
            let orderCurrency = input.billingFilter.order.currency,
            let paymentCurrency = input.billingFilter.payment.currency
        else { currencyContainer.isHidden = true; return }
        
        let currencyHidden = input.billingFilter.isCurrencyEqual
        
        currencyContainer.isHidden = currencyHidden
        
        currencyTitleLabel.text = "currency".localized(.billing) + ": " + paymentCurrency
        checkCurrency()
    }
    
    public func otpFieldChanged() {
        
        switch input.billingFilter.payment.otpState {
        case .otp:
            otpField.startTimer()
        case .payment:
            break
        case .default:
            otpField.finishTiming()
        }
        
    }
    
    public func checkButtonState() {
        
        var isValidated = true
        
        checkErrorMessage()
        
        if !amountField.isValidated(withMessage: true) {
            isValidated = false
        }
        
        if input.billingFilter.payment.paymentState == .none {
            isValidated = false
        }
        
        if input.billingFilter.payment.otpState != .default {
            if !otpField.isValidated(withMessage: true) {
                isValidated = false
            }
        }
        
        isValidated ? payButton.enableButton() : payButton.disableButton()
    }
    
}

private extension BillingPaymentViewController {
    func amountChanged() {
        input.billingFilter.amount = amountField.getValue().int
        checkButtonState()
        otpFieldChanged()
        checkCurrency()
    }
    
    func checkCurrency() {
        currencyValueLabel.text = ((input.currency?.getRate() ?? 0) * amountField.getValue().double).string.originalPriceWithoutCurrency
        
    }
    
    func loadCurrency() {
        viewModel.loadCurrency(filter: input.billingFilter)
    }
}
