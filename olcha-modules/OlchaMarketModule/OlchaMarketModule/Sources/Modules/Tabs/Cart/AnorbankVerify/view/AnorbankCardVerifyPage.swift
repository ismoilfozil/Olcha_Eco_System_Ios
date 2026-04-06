//
//  AnorbankCardVerifyPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/11/22.
//

import UIKit
import Combine
import IQKeyboardManagerSwift
import OlchaBankCards
#warning("anorbank stopped working")
class AnorbankCardVerifyPage: BaseViewController {
//    
//    private let cardFill = CardFillView()
//    
//    private var bag = Set<AnyCancellable>()
//    
//    let observers = CardFillObservers()
//    
//    let viewModel = AnorbankViewModel()
//    
//    weak var verifyObserver: PassthroughSubject<Bool, Never>?
//
//    var orderID: Int?
//    override func viewDidLoad() {
//        setupModalViews()
//        modalAutolayout()
//        configureModalViews(header: "anorbank_verify".localized())
//        setupObservers()
//    }
//    
//    override func setupModalViews() {
//        super.setupModalViews()
//        modalContainer.addSubview(cardFill)
//    }
//    
//    override func modalAutolayout() {
//        super.modalAutolayout()
//        cardFill.snp.makeConstraints { make in
//            make.top.left.right.equalToSuperview().inset(16)
//            make.bottom.equalToSuperview().inset(16).priority(.high)
//        }
//
//    }
//    
//    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
//        super.configureModalViews(header: header, textAlignment: textAlignment)
//        dismissConfiguration()
//        
//        cardFill.observers = observers
//        cardFill.withPhone = false
//        
//        IQKeyboardManager.shared.keyboardDistanceFromTextField = 16
//        
//    }
//    
//    override func setupObservers() {
//        super.baseSetupObservers(viewModel: viewModel)
////        viewModel
////            .$cardUploadedSuccess
////            .sink { [weak self] isSuccess in
////                guard let self = self, isSuccess else { return }
////                self.dismiss(animated: true, completion: {
////                    self.verifyObserver?.send(true)
////                })
////            }.store(in: &bag)
////        
////        viewModel
////            .$cardUploadedError
////            .sink { [weak self] isError in
////                guard let self = self, isError else { return }
////                self.observers.requestFinished.send(true)
////            }.store(in: &bag)
////        
////        viewModel
////            .$verifyCardError
////            .sink { [weak self] isError in
////                guard let self = self, isError else { return }
////                self.observers.requestFinished.send(true)
////            }.store(in: &bag)
////        
//        viewModel
//            .$codeSent
//            .sink { [weak self] isSent in
//                guard let self = self, isSent else { return }
//                self.observers.requestFinished.send(true)
//                self.observers.codeSentObserver.send(true)
//            }.store(in: &bag)
//        
//        observers.sendCodeObserver
//            .sink { [weak self] model in
//                guard let self = self else { return }
//                
//                self.viewModel.sendOTP(expiry: model.expiry,
//                                       pan: model.pan,
//                                       order_id: self.orderID)
//
//            }.store(in: &bag)
//        
//        observers.sendCardObserver
//            .sink { [weak self] model in
//                guard let self = self else { return }
//                self.viewModel.verifyOTP(paymentID: self.viewModel.sendOTPResponse?.payment_id,
//                                         otp: model.code)
//            }.store(in: &bag)
//    }
    
}
