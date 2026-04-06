//
//  AnorbankViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/11/22.
//

import Foundation
import Combine
import OlchaBankCards
#warning("errors commented")
//class AnorbankViewModel: BankCardViewModel {
//    
//    let sendOTPIndicator = CurrentValueSubject<Bool, Never>(false)
//    let verifyOTPIndicator = CurrentValueSubject<Bool, Never>(false)
//    
//    @Published var sendOTPResponse: AddAnorbankResponse?
//    @Published var sendOTPError: Bool = false
//    @Published var verifyOTPResponse: VerifyAnorbankResponse?
//    @Published var verifyOTPError: Bool = false
//    
//    func sendOTP(expiry: String?, pan: String?, order_id: Int?) {
//        guard let expiry = expiry?.phoneNumber,
//              let pan = pan?.phoneNumber,
//              let order_id = order_id else {
//                  return
//              }
//
//        
//        guard pan.count > 8, MarketTexts.anorbankCreditCards.contains(pan[0...7]) else {
//            self.show(error: "not_anorbank_credit_card".localized())
//            return
//        }
//        
//        let request = AddAnorbankRequest(expiry: expiry, order_id: order_id, pan: pan)
//        let api: AnorbankAPI = .sendOTP(model: request)
//        
//        self.startRequesting(api: api,
//                             isSingleRequest: true,
//                             indicator: sendOTPIndicator) { [weak self] (data: AddAnorbankResponse?) in
//            guard let self = self else { return }
//            self.codeSent = true
//            self.sendOTPResponse = data
//        } onError: { [weak self] message in
//            guard let self = self else { return }
//            FirebaseLogger.otherlog(message: message, api: api)
//            self.sendOTPError = true
////            self.verifyCardError = true
//            self.show(error: message)
//            FirebaseLogger.otherlog(message: message, api: api)
//        }
//        
//    }
//    
//    func verifyOTP(paymentID: Int?, otp: String?) {
//        guard let paymentID = paymentID,
//              let otp = otp
//        else {
//            return
//        }
//        
//        let request = VerifyAnorbankRequest(payment_id: paymentID, otp: otp)
//        let api: AnorbankAPI = .verifyOTP(model: request)
//        
//        self.startRequesting(api: api,
//                             isSingleRequest: true,
//                             indicator: verifyOTPIndicator) { [weak self] (data: VerifyAnorbankResponse?) in
//            guard let self = self else { return }
////            self.cardUploadedSuccess = data?.success ?? false
//            if !(data?.success ?? false) {
//                self.verifyError(message: data?.responseText ?? MarketTexts.fail, api: api)
//            }
//        } onError: { [weak self] message in
//            guard let self = self else { return }
//            self.verifyError(message: message, api: api)
//        }
//    }
//    
//    private func verifyError(message: String?, api: OlchaMarketAPI) {
//        FirebaseLogger.otherlog(message: message, api: api)
//        self.verifyOTPError = true
////        self.cardUploadedError = true
//        self.show(error: message)
//        FirebaseLogger.otherlog(message: message, api: api)
//    }
//}
//
