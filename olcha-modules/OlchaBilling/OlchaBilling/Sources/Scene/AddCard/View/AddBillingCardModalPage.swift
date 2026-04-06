//
//  AddBillingCardModalPage.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 10/07/23.
//

import UIKit
import OlchaUI
import OlchaBankCards
import OlchaUtils
import OlchaCore
import SnapKit

public class AddBillingCardModalPage: AddCardModalPage {
    
    private lazy var keyboardManager = KeyboardManager()
    public var filter = BillingPaymentFilter()
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        keyboardManager.startObservingKeyboard()
//        keyboardManager.keyboardWillShowObserver = keyboardWillShowObserver
//        keyboardManager.keyboardWillHideObserver = keyboardWillHideObserver
        cardFill.cardNumberField.settings.becomeFirstResponder()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        keyboardManager.stopObservingKeyboard()
    }
    
    public override func sendCodeObserver() {
        observers.sendCodeObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                self.viewModel.verifyBankCardPhone(model: model, filter: filter)
            }.store(in: &bag)
    }
    
    public override func sendCardObserver() {
        observers.sendCardObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                self.viewModel.uploadBankCard(model: model, filter: filter)
            }.store(in: &bag)
    }
    
    public override func bankCardObserver() {
        handle(viewModel.$bankCard,
               showLoader: true,
               withError: false) { [weak self] data in
            guard let self = self,
                  let _ = data else { return }
            self.observers.requestFinished.send(true)
            uploadedSuccessfully()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.observers.requestFinished.send(true)
            checkError(error: error)
        }
    }
    
}

private extension AddBillingCardModalPage {
    func keyboardWillShowObserver(height: CGFloat, timeInterval: TimeInterval) {
        container.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(height)
        }
        UIView.animate(withDuration: timeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHideObserver() {
        container.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(UIApplication.shared.bottomInset)
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func checkError(error: CardUploadError?) {
        if error?.code == AddBillingCardError.exists.rawValue {
            creditVerificationObserver?()
            uploadedSuccessfully()
        } else {
            self.observers.requestFinished.send(true)
            showError(text: error?.message)
        }
    }
}
