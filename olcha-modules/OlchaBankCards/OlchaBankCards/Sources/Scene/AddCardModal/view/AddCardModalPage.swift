//
//  AddCardModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/09/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaUtils
import IQKeyboardManagerSwift
open class AddCardModalPage: BaseModalViewController {

    public let cardFill = CardFillView()
    
    public let viewModel: BankCardViewModel
    
    public let observers = CardFillObservers()
    
    public weak var loadCards: PassthroughSubject<Bool, Never>?
    
    public var creditVerificationObserver: (() -> Void)?
    
    public init(viewModel: BankCardViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(cardFill)
    }
    
    public override func autolayout() {
        cardFill.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        setHeader(title: "add_new_card".localized())
        dismissConfiguration()
        
        cardFill.observers = observers
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 16
    }
    
    public override func setupObservers() {
        
        cardUploadedObserver()
        
        bankCardObserver()
        
        codeSentObserver()
        
        viewModel.creditVerificationObserver = creditVerificationObserver
        
        sendCodeObserver()
        
        sendCardObserver()
        
    }
    
    open func cardUploadedObserver() {
        handle(viewModel.$cardUploaded, showLoader: true) { [weak self] data in
            guard let self = self, data != nil else { return }
            uploadedSuccessfully()
        } failure: { [weak self] error in
            guard let self = self, error != nil else { return }
            self.observers.requestFinished.send(true)
        }
    }
    
    open func bankCardObserver() {
        handle(viewModel.$bankCard, showLoader: true) { [weak self] data in
            guard let self = self,
                  let _ = data else { return }
            self.observers.requestFinished.send(true)
            uploadedSuccessfully()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.observers.requestFinished.send(true)
        }
    }
    
    open func codeSentObserver() {
        viewModel
            .$codeSent
            .sink { [weak self] isSent in
                guard let self = self, isSent else { return }
                self.observers.requestFinished.send(true)
                self.observers.codeSentObserver.send(true)
            }.store(in: &bag)
    }
    
    open func sendCodeObserver() {
        observers.sendCodeObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                self.viewModel.verifyBankCardPhone(model: model)
            }.store(in: &bag)
    }
    
    open func sendCardObserver() {
        observers.sendCardObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                self.viewModel.uploadBankCard(model: model)
            }.store(in: &bag)
    }
    
    public func uploadedSuccessfully() {
        loadCards?.send(true)
        dismiss(animated: true, completion: nil)
    }
}
