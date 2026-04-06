//
//  EnterPaymentPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/11/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaUtils
public class EnterPaymentPage: BaseViewController<BackNavigationBar> {

    private let paymentTextField: TField = {
        let field = TField()
        field.topHint = "enter_payment".localized()
        field.placeholder = "summa".localized()
        field.field_tag = (\FillPaymentRequest.amount).propertyName
        return field
    }()
    
    private let acceptButton = OlchaButton()
    
    weak var coordinator: BalanceCoordinatorProtocol?
    
    public var payment: Payments?
    
    let viewModel: BalanceViewModel
    
    public override var validatedFields: [TField] {
        [paymentTextField]
    }
    
    public init(viewModel: BalanceViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(paymentTextField)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        paymentTextField.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle(payment?.getName() ?? "")
        
        paymentTextField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkPaymentButtonState()
        }
        
        acceptButton.setTitle("fill_balans".localized())
        acceptButton.disableButton()
        
        if let min_amount = payment?.min_amount,
           let max_amount = payment?.max_amount {
            if max_amount > min_amount {
                paymentTextField.type = .amountRanged(range: (min: min_amount.double, max: max_amount.double))
            } else {
                paymentTextField.type = .amountRanged(range: (min: min_amount.double, max: nil))
            }
        } else {
            paymentTextField.type = .amount
        }
    }
    
    public override func setupObservers() {
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.viewModel.enterPayment(amount: self.paymentTextField.getText(),
                                        payment: self.payment)
        }
        
        
        handle(viewModel.$paymentRedirectURL) { [weak self] data in
            guard let self = self, let data = data else { return }
            self.coordinator?.pushPayPage(url: data)
        } loading: { [weak self] isLoading in
            guard let self else { return }
            self.acceptButton.settings.requesting = isLoading
        }

    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc public  func keyboardWillShow(notification: Notification) {
        guard let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        animateButton(inset: height + 16 - (tabBarController?.tabBar.frame.height ?? 0))
    }
    
    @objc public  func keyboardWillHide(notification: Notification) {
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
    
    private func checkPaymentButtonState() {
        paymentTextField.isValidated() ? acceptButton.enableButton() : acceptButton.disableButton()
    }
    
}
