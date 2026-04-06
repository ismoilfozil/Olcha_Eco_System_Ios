//
//  EnterPaymentPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/11/22.
//

import UIKit
import Combine
import OlchaBankCards
import OlchaUI
import OlchaCore
class EnterPaymentCardPage: BaseViewController<BackNavigationBar> {

    private let paymentTextField: TField = {
        let field = TField()
        field.topHint = "enter_payment".localized()
        field.placeholder = "summa".localized()
        field.field_tag = (\CardPaymentRequest.amount).propertyName
        return field
    }()
    
    private let codeTextField: TField = {
        let field = TField()
        field.topHint = "code".localized()
        field.placeholder = "0000"
        field.isHidden = true
        field.settings.keyboardType = .numberPad
        field.field_tag = (\ProvideOTPPaymentRequest.otp).propertyName
        return field
    }()
    
    private let acceptButton = OlchaButton()
    
    enum ButtonType {
        case payment
        case code
    }
    
    var type: ButtonType = .payment {
        didSet {
            if type == .payment {
                acceptButton.setTitle("fill_balans".localized())
                codeTextField.isHidden = true
                checkPaymentButtonState()
            } else {
                acceptButton.setTitle("fill_code".localized())
                codeTextField.isHidden = false
                checkCodeButtonState()
            }
        }
    }
    
    var bankCard: BankCard?
    
    weak var coordinator: BalanceCoordinatorProtocol?
    
    var payment: String = ""
    
    let viewModel : BalanceViewModel
    
    override var validatedFields: [TField] {
        type == .payment ? [paymentTextField] : [paymentTextField, codeTextField]
    }
    
    public init(viewModel: BalanceViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var transaction: CardPaymentData?
    
    public override func setupViews() {
        container.addSubview(paymentTextField)
        container.addSubview(codeTextField)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        paymentTextField.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(16)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.top.equalTo(paymentTextField.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {

        navigationBar.setTitle(bankCard?.card_number?.makeReadableCardNumber.hideCardNumber ?? "")
        
        
        if let min_amount = bankCard?.min_amount,
           let max_amount = bankCard?.max_amount {
            if max_amount > min_amount {
                paymentTextField.type = .amountRanged(range: (min: min_amount.double, max: max_amount.double))
            } else {
                paymentTextField.type = .amountRanged(range: (min: min_amount.double, max: nil))
            }
        } else {
            paymentTextField.type = .amount
        }
        self.type = .payment
    }
    
    public override func setupObservers() {
        
        paymentTextField.observeText { [weak self] in
            guard let self = self else { return }
            if self.payment != self.paymentTextField.getText() {
                self.type = .payment
                self.payment = self.paymentTextField.getText()
            }
            
            if self.type == .payment {
                self.checkPaymentButtonState()
            } else {
                self.checkCodeButtonState()
            }
        }
        
        codeTextField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkCodeButtonState()
        }
        
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            if self.type == .payment {
                self.viewModel.getSecureCodePayment(card: self.bankCard,
                                                    amount: self.paymentTextField.getValue())
            } else {
                self.viewModel.providePaymentOTP(otp: self.codeTextField.getValue())
            }
        }
        
        handle(viewModel.$paymentTransaction, withError: false) {  [weak self] data in
            guard let self = self else { return }
            /// `Last version was "otp" field for check otp successfully sent`
//            if (data?.otp ?? false) {
                self.type = .code
                self.transaction = data
//            } else {
//                finishTransaction()
//            }
        } failure: { [weak self] error in
            guard let self else { return }
            showValidateError(error)
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.acceptButton.settings.requesting = isLoading
        }

        
        handle(viewModel.$paymentTransactionFinished, success: { [weak self] data in
            guard let self = self, data != nil else { return }
            finishTransaction()
        }, loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.acceptButton.settings.requesting = isLoading
        })
    
    }
    
    private func finishTransaction() {
        showSuccess(text: "payment_successfull".localized()) { [weak self] in
            guard let self = self else { return }
            coordinator?.dismissToRoot()
        }
    }
    
    private func showValidateError(_ error: BaseErrorType?) {
        if let error = error?.message {
            validatedFields.last?.errorMessage(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        animateButton(inset: height + 16 - (tabBarController?.tabBar.frame.height ?? 0))
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        animateButton(inset: 16)
    }
    
    private func animateButton(inset: CGFloat) {
        
        acceptButton.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(inset)
        }
            
        UIView.animate(withDuration: 0.4) {
            self.container.layoutIfNeeded()
        }
                
    }
    
    private func checkCodeButtonState() {
        if paymentTextField.isValidated() && codeTextField.getText() != "" {
            acceptButton.enableButton()
        } else {
            acceptButton.disableButton()
        }
    }
    
    private func checkPaymentButtonState() {
        if paymentTextField.isValidated() {
            acceptButton.enableButton()
        } else {
            acceptButton.disableButton()
        }
    }
    
}
